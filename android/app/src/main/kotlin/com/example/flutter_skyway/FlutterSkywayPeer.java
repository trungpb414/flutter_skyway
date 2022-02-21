package com.example.flutter_skyway;

import android.app.Activity;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import org.json.JSONArray;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.skyway.Peer.Browser.Canvas;
import io.skyway.Peer.Browser.MediaConstraints;
import io.skyway.Peer.Browser.MediaStream;
import io.skyway.Peer.Browser.Navigator;
import io.skyway.Peer.CallOption;
import io.skyway.Peer.MediaConnection;
import io.skyway.Peer.OnCallback;
import io.skyway.Peer.Peer;
import io.skyway.Peer.PeerError;
import io.skyway.Peer.Room;
import io.skyway.Peer.RoomOption;

public class FlutterSkywayPeer {
    private static final boolean DEBUG = true;
    private static final String TAG = FlutterSkywayPeer.class.getSimpleName();

    public interface OnListAllPeersCallback {
        public void onListAllPeers(@NonNull final List<String> list);
    }

    @NonNull
    private final Object mSync = new Object();
    @NonNull
    private final Activity activity;
    @NonNull
    private final EventChannel _Eventchannel;
    @NonNull
    private final String _peerId;
    @NonNull
    private final Peer _peer;
    @Nullable
    private EventChannel.EventSink _eventSink;
    private MediaStream _localStream;
    private MediaConnection _mediaConnection;
    @Nullable
    private String _roomName;
    @Nullable
    private RoomOption.RoomModeEnum _roomMode;
    @Nullable
    private Room _room;

    private int _localVideoId = -1;
    private Canvas _localCanvas;

    @NonNull
    private final Handler _handler = new Handler(Looper.getMainLooper());
    @NonNull
    private final Map<String, RemotePeer> mRemotes = new HashMap<>();

    public FlutterSkywayPeer(@NonNull final Activity activity,
                             @NonNull final String peerId,
                             @NonNull final Peer peer,
                             @NonNull final BinaryMessenger binaryMessenger) {

        if (DEBUG) Log.v(TAG, "FlutterSkywayPeer:");
        this.activity = activity;
        _peerId = peerId;
        _peer = peer;
        _Eventchannel = new EventChannel(binaryMessenger,
                Const.PEER_EVENT_CHANNEL_NAME + "_" + peer.identity());
        _Eventchannel.setStreamHandler(mStreamHandler);


        _peer.on(Peer.PeerEventEnum.DISCONNECTED, new OnCallback() {
            @Override
            public void onCallback(Object object) {
                if (DEBUG) Log.v(TAG, "PeerEventEnum.DISCONNECTED:" + object);
                sendEmptyMessage(Const.SkywayEvent.onDisconnect);
            }
        });


        _peer.on(Peer.PeerEventEnum.CALL, new OnCallback() {
            @Override
            public void onCallback(Object object) {
                if (DEBUG) Log.v(TAG, "PeerEventEnum.CALL:" + object);
                if (!(object instanceof MediaConnection)) {
                    return;
                }

                _mediaConnection = (MediaConnection) object;
                setMediaCallbacks(_mediaConnection);

                _mediaConnection.answer(_localStream);
                final Map<String, String> message
                        = createMessage(Const.SkywayEvent.onCall);
                message.put("remotePeerId", _mediaConnection.peer());
                try {
                    sendMessage(message);
                } catch (final Exception e) {
                    Log.w(TAG, "PeerEventEnum.CAL: EventChannel is not ready ro already released.", e);
                }
            }
        });
    }

    public void hangUp() {
        if (DEBUG) Log.v(TAG, "hangUp:");
        closeRemoteStreamAll();

        if (_mediaConnection != null) {
            if (_mediaConnection.isOpen()) {
                _mediaConnection.close();
            }
            unsetMediaCallbacks(_mediaConnection);
            _mediaConnection = null;
        }

        if (_roomName != null) {
            leave(_roomName);
        }
    }

    public void startCall(@NonNull final String remotePeerId)
            throws IllegalStateException {

        if (DEBUG) Log.v(TAG, "startCall:" + remotePeerId);
        if (!isConnected() || (_localStream == null)) {
            throw new IllegalStateException("Already released or not started local stream");
        }

        if (_mediaConnection != null) {
            _mediaConnection.close();
        }
        if (_room != null) {
            unsetRoomCallback(_room);
            _room = null;
        }

        final CallOption option = new CallOption();
        _mediaConnection = _peer.call(remotePeerId, _localStream, option);

        if (_mediaConnection != null) {
            setMediaCallbacks(_mediaConnection);
        }

    }

    public void join(@NonNull final String roomName, final RoomOption.RoomModeEnum mode)
            throws IllegalStateException {

        if (DEBUG) Log.v(TAG, "join:" + roomName + ",mode=" + mode);
        if (!isConnected() || (_localStream == null)) {
            throw new IllegalStateException("Already released or not started local stream");
        }

        if (_mediaConnection != null) {
            _mediaConnection.close();
        }
        if ((_room == null) || !roomName.equals(_roomName) || !mode.equals(_roomMode)) {
            if (_room != null) {
                unsetRoomCallback(_room);
                _room = null;
            }
            final RoomOption option = new RoomOption();
            option.mode = mode;
            option.stream = _localStream;


            _room = _peer.joinRoom(roomName, option);
            _roomName = roomName;
            _roomMode = mode;
            setRoomCallback(_room);
        }
    }

    public void leave(@NonNull final String roomName) {
        if (DEBUG) Log.v(TAG, "leave:");
        if (isConnected() && _room != null) {
            _room.close();
            _roomName = null;
            _roomMode = null;
        }
    }

    public void listAllPeers(@NonNull OnListAllPeersCallback callback) {
        if (DEBUG) Log.v(TAG, "listAllPeers:");
        if (!isConnected()) {
            callback.onListAllPeers(Collections.emptyList());
        } else {

            _peer.listAllPeers(new OnCallback() {
                @Override
                public void onCallback(Object object) {
                    if (!(object instanceof JSONArray)) {
                        callback.onListAllPeers(Collections.emptyList());
                        return;
                    }

                    final JSONArray peers = (JSONArray) object;
                    final List<String> peerIds = new ArrayList<>();
                    String peerId;


                    for (int i = 0; peers.length() > i; i++) {
                        try {
                            peerId = peers.getString(i);
                            if (!_peerId.equals(peerId)) {
                                peerIds.add(peerId);
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                    callback.onListAllPeers(peerIds);
                }
            });
        }
    }

    public void startLocalStream(final int localVideoId)
            throws IllegalArgumentException {

        if (DEBUG) Log.v(TAG, "startLocalStream:" + localVideoId);
        if (_localVideoId != localVideoId) {
            if (_localStream != null && _localCanvas != null) {
                _localStream.removeVideoRenderer(_localCanvas, 0);
            }
            if (_localStream == null) {
                final MediaConstraints constraints = new MediaConstraints();
                constraints.maxWidth = 100;
                constraints.maxHeight = 100;
                constraints.cameraPosition = MediaConstraints.CameraPositionEnum.FRONT;

                Navigator.initialize(_peer);
                _localStream = Navigator.getUserMedia(constraints);
            }
            _localCanvas = getCanvas(localVideoId);
            if (_localCanvas != null) {
                _localVideoId = localVideoId;
                _localStream.addVideoRenderer(_localCanvas, 0);
                _localStream.setEnableAudioTrack(0, true);
            } else {

                throw new IllegalArgumentException();
            }
        }
    }

    public void startRemoteStream(
            final int remoteVideoId, final String remotePeerId)
            throws IllegalArgumentException {

        if (DEBUG) Log.v(TAG, "startRemoteStream:" + remoteVideoId);
        final RemotePeer remote = getRemote(remotePeerId);
        if (remote != null) {
            final Canvas canvas = getCanvas(remoteVideoId);
            if (canvas != null) {
                remote.setCanvas(canvas);
            } else {

                throw new IllegalArgumentException("Specific canvas,id=" + remoteVideoId);
            }
        } else {
            throw new IllegalArgumentException("Specific remote peer not found,remote peer=" + remotePeerId);
        }
    }

    public void release() {
        if (DEBUG) Log.v(TAG, "release:");
        closeRemoteStreamAll();

        if (_localStream != null) {
            if (_localCanvas != null) {
                _localStream.removeVideoRenderer(_localCanvas, 0);
                _localCanvas = null;
            }
            _localStream.close();
            _localStream = null;
        }

        if (_mediaConnection != null) {
            if (_mediaConnection.isOpen()) {
                _mediaConnection.close();
            }
            unsetMediaCallbacks(_mediaConnection);
            _mediaConnection = null;
        }

        Navigator.terminate();

        if (isConnected()) {
            unsetPeerCallback(_peer);
            if (!_peer.isDisconnected()) {
                _peer.disconnect();
            }

            if (!_peer.isDestroyed()) {
                _peer.destroy();
            }
        }
        if (_eventSink != null) {
            sendEmptyMessage(Const.SkywayEvent.onRelease);
            _eventSink = null;
        }
    }

    private boolean isConnected() {
        return !_peer.isDestroyed() && !_peer.isDisconnected();
    }

    @NonNull
    private Map<String, String> createMessage(final Const.SkywayEvent event) {
        final Map<String, String> message = new HashMap<>();
        message.put("event", event.name());
        message.put("peerId", _peerId);
        return message;
    }

    private void sendMessage(@NonNull final Map<String, String> message)
            throws IllegalStateException {

        synchronized (mSync) {
            if (_eventSink != null) {
                _eventSink.success(message);
            } else {
                throw new IllegalStateException("EventSink not ready or already released.");
            }
        }
    }

    private void sendEmptyMessage(Const.SkywayEvent event) {
        sendMessage(createMessage(event));
    }

    private final EventChannel.StreamHandler mStreamHandler
            = new EventChannel.StreamHandler() {
        @Override
        public void onListen(final Object arguments, final EventChannel.EventSink events) {
            if (DEBUG) Log.v(TAG, "onListen:" + events);
            synchronized (mSync) {
                _eventSink = events;
                sendEmptyMessage(Const.SkywayEvent.onConnect);
            }
        }

        @Override
        public void onCancel(final Object arguments) {
            if (DEBUG) Log.v(TAG, "onCancel:" + arguments);
        }
    };

    private void unsetPeerCallback(@NonNull Peer peer) {
        if (DEBUG) Log.v(TAG, "unsetPeerCallback:");
        peer.on(Peer.PeerEventEnum.OPEN, null);
        peer.on(Peer.PeerEventEnum.CONNECTION, null);
        peer.on(Peer.PeerEventEnum.CALL, null);
        peer.on(Peer.PeerEventEnum.CLOSE, null);
        peer.on(Peer.PeerEventEnum.DISCONNECTED, null);
        peer.on(Peer.PeerEventEnum.ERROR, null);
    }

    private void setMediaCallbacks(@NonNull final MediaConnection mediaConnection) {
        if (DEBUG) Log.v(TAG, "setMediaCallbacks:");

        mediaConnection.on(MediaConnection.MediaEventEnum.STREAM, new OnCallback() {
            @Override
            public void onCallback(Object object) {
                if (DEBUG) Log.v(TAG, "MediaEventEnum.STREAM:" + object);
                if (object instanceof MediaStream) {
                    addRemoteStream((MediaStream) object);
                }
            }
        });

        mediaConnection.on(MediaConnection.MediaEventEnum.CLOSE, new OnCallback() {
            @Override
            public void onCallback(Object object) {
                if (DEBUG) Log.v(TAG, "MediaEventEnum.CLOSE:" + object);
                if (object instanceof MediaConnection) {
                    final MediaConnection connection = (MediaConnection) object;
                    final String remotePeerId = connection.peer();
                    removeRemoteStream(remotePeerId);
                }
                try {
                    sendEmptyMessage(Const.SkywayEvent.onDisconnect);
                } catch (final Exception e) {
                    if (DEBUG) Log.w(TAG, e);
                }
            }
        });


        mediaConnection.on(MediaConnection.MediaEventEnum.ERROR, new OnCallback() {
            @Override
            public void onCallback(Object object) {
                if (DEBUG) Log.d(TAG, "MediaEventEnum.ERROR:" + object);
                if (object instanceof PeerError) {
                    final PeerError error = (PeerError) object;
                    final Map<String, String> message
                            = createMessage(Const.SkywayEvent.onError);
                    message.put("error", error.toString());
                    try {
                        sendMessage(message);
                    } catch (final Exception e) {
                        if (DEBUG) Log.w(TAG, e);
                    }
                }
            }
        });
    }

    private void unsetMediaCallbacks(@NonNull final MediaConnection mediaConnection) {
        if (DEBUG) Log.v(TAG, "unsetMediaCallbacks:");
        mediaConnection.on(MediaConnection.MediaEventEnum.STREAM, null);
        mediaConnection.on(MediaConnection.MediaEventEnum.CLOSE, null);
        mediaConnection.on(MediaConnection.MediaEventEnum.ERROR, null);
    }

    private void setRoomCallback(@NonNull final Room room) {
        room.on(Room.RoomEventEnum.OPEN, new OnCallback() {
            @Override
            public void onCallback(Object object) {
                if (DEBUG) Log.v(TAG, "RoomEventEnum.OPEN:" + object);
                if (object instanceof String) {
                    final Map<String, String> message
                            = createMessage(Const.SkywayEvent.onOpenRoom);
                    message.put("room", (String) object);
                    sendMessage(message);
                }
            }
        });
        room.on(Room.RoomEventEnum.CLOSE, new OnCallback() {
            @Override
            public void onCallback(Object object) {
                if (DEBUG) Log.v(TAG, "RoomEventEnum.CLOSE:" + object);
                closeRemoteStreamAll();
                if (_room != null) {
                    unsetRoomCallback(_room);
                    _room = null;
                    _roomName = null;
                    _roomMode = null;
                }
                if (object instanceof String) {
                    final Map<String, String> message
                            = createMessage(Const.SkywayEvent.onCloseRoom);
                    message.put("room", (String) object);
                    try {
                        sendMessage(message);
                    } catch (final Exception e) {
                        if (DEBUG) Log.w(TAG, e);
                    }
                }
            }
        });
        room.on(Room.RoomEventEnum.ERROR, new OnCallback() {
            @Override
            public void onCallback(Object object) {
                if (DEBUG) Log.w(TAG, "RoomEventEnum.ERROR:" + object);
                if (object instanceof PeerError) {
                    final PeerError error = (PeerError) object;
                    final Map<String, String> message
                            = createMessage(Const.SkywayEvent.onError);
                    message.put("error", error.toString());
                    try {
                        sendMessage(message);
                    } catch (final Exception e) {
                        if (DEBUG) Log.w(TAG, e);
                    }
                }
            }
        });
        room.on(Room.RoomEventEnum.PEER_JOIN, new OnCallback() {
            @Override
            public void onCallback(Object object) {
                if (DEBUG) Log.v(TAG, "RoomEventEnum.PEER_JOIN:");
                if (object instanceof String) {
                    final Map<String, String> message
                            = createMessage(Const.SkywayEvent.onJoin);
                    message.put("remotePeerId", (String) object);
                    sendMessage(message);
                }
            }
        });
        room.on(Room.RoomEventEnum.PEER_LEAVE, new OnCallback() {
            @Override
            public void onCallback(Object object) {
                if (DEBUG) Log.v(TAG, "RoomEventEnum.PEER_LEAVE:" + object);
                if (object instanceof String) {
                    final String peerId = (String) object;
                    final Map<String, String> message
                            = createMessage(Const.SkywayEvent.onRelease);
                    message.put("remotePeerId", peerId);
                    sendMessage(message);
                    removeRemoteStream(peerId);
                }
            }
        });
        room.on(Room.RoomEventEnum.STREAM, new OnCallback() {
            @Override
            public void onCallback(Object object) {
                if (DEBUG) Log.v(TAG, "RoomEventEnum.STREAM: + " + object);
                if (object instanceof MediaStream) {
                    final MediaStream stream = (MediaStream) object;
                    addRemoteStream(stream);
                }
            }
        });

        room.on(Room.RoomEventEnum.REMOVE_STREAM, new OnCallback() {
            @Override
            public void onCallback(Object object) {
                if (DEBUG) Log.v(TAG, "RoomEventEnum.REMOVE_STREAM: " + object);
                if (object instanceof MediaStream) {
                    final MediaStream stream = (MediaStream) object;
                    removeRemoteStream(stream.getPeerId());
                }
            }
        });
    }

    private void unsetRoomCallback(@NonNull final Room room) {
        room.on(Room.RoomEventEnum.OPEN, null);
        room.on(Room.RoomEventEnum.CLOSE, null);
        room.on(Room.RoomEventEnum.ERROR, null);
        room.on(Room.RoomEventEnum.PEER_JOIN, null);
        room.on(Room.RoomEventEnum.PEER_LEAVE, null);
        room.on(Room.RoomEventEnum.STREAM, null);
        room.on(Room.RoomEventEnum.REMOVE_STREAM, null);
    }

    @Nullable
    private Canvas getCanvas(final int id) {
        final FlutterSkywayCanvas view
                = FlutterSkywayCanvas.Companion.findViewById(id);
        final Canvas result = view != null ? view.getCanvas() : null;
        if (DEBUG && (result == null))
            Log.v(TAG, String.format("getCanvas:Canvas(id=%d) not found.", id));
        return result;
    }

    private void closeRemoteStreamAll() {
        if (DEBUG) Log.v(TAG, "closeRemoteStreamAll:");
        final Map<String, RemotePeer> copy;
        synchronized (mRemotes) {
            copy = new HashMap<>(mRemotes);
            mRemotes.clear();
        }
        for (final RemotePeer remote : copy.values()) {
            remote.release();
            final Map<String, String> message
                    = createMessage(Const.SkywayEvent.onRemoveRemoteStream);
            message.put("remotePeerId", remote.peerId);
            try {
                sendMessage(message);
            } catch (final Exception e) {
                if (DEBUG) Log.w(TAG, e);
            }
        }
    }

    @Nullable
    private RemotePeer getRemote(final String remotePeerId) {
        synchronized (mRemotes) {
            return mRemotes.containsKey(remotePeerId) ? mRemotes.get(remotePeerId) : null;
        }
    }

    private void addRemoteStream(@NonNull final MediaStream remoteStream) {
        if (DEBUG) Log.v(TAG, "addRemoteStream:" + remoteStream);
        final String remotePeerId = remoteStream.getPeerId();
        synchronized (mRemotes) {
            RemotePeer peer = mRemotes.remove(remotePeerId);
            if (peer != null) {
                peer.release();
            }
            peer = new RemotePeer(remotePeerId, remoteStream);
            mRemotes.put(remotePeerId, peer);
        }
        final Map<String, String> message = createMessage(Const.SkywayEvent.onAddRemoteStream);
        message.put("remotePeerId", remotePeerId);
        sendMessage(message);
    }

    private void removeRemoteStream(@NonNull final String remotePeerId) {
        if (DEBUG) Log.v(TAG, "removeRemoteStream:" + remotePeerId);
        @Nullable final RemotePeer peer;
        synchronized (mRemotes) {
            peer = mRemotes.remove(remotePeerId);
        }
        if (peer != null) {
            peer.release();
        }
    }

}
