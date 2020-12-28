import 'dart:math';

import 'package:flt_im_plugin/flt_im_plugin.dart';
import 'package:flt_im_plugin/message.dart';
import 'package:flt_im_plugin/value_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geen/app/res/cons.dart';
import 'peer_event.dart';
import 'peer_state.dart';



class PeerBloc extends Bloc<PeerEvent, PeerState> {


  PeerBloc();

  @override
  PeerState get initialState => PeerInital();

  Color get activeHomeColor {
    return Color(Cons.tabColors[0]);
  }

  @override
  Stream<PeerState> mapEventToState(PeerEvent event) async* {
    if (event is PeerInital) {


    }

    if (event is EventSendNewMessage) {
        FltImPlugin im = FltImPlugin();
        Map result = await im.sendTextMessage(
          secret: false,
          sender: event.currentUID,
          receiver: event.peerUID,
          rawContent: event.content ?? 'hello world',
        );
          List<Message> newMessage =[];
          Map response = await im.loadData();
          var  messages = ValueUtil.toArr(response["data"]).map((e) => Message.fromMap((e))).toList();

          newMessage.addAll(messages.reversed.toList());

        yield PeerMessageSuccess(newMessage,event.peerUID);
      }
    if (event is EventSendNewImageMessage) {
      FltImPlugin im = FltImPlugin();
      Map result = await im.sendImageMessage(
        secret: false,
        sender: event.currentUID,
        receiver: event.peerUID,
        image: event.content,
      );
      List<Message> newMessage =[];
      Map response = await im.loadData();
      var  messages = ValueUtil.toArr(response["data"]).map((e) => Message.fromMap((e))).toList();

      newMessage.addAll(messages.reversed.toList());

      yield PeerMessageSuccess(newMessage,event.peerUID);
    }
    if (event is EventReceiveNewMessage) {

      try {

          String cunrrentId;
          List<Message> newMessage =[];
          if (state is PeerMessageSuccess){
            Message mess =Message.fromMap(event.message);
            cunrrentId= state.props.elementAt(1);
            if (cunrrentId != null && mess.sender!=cunrrentId){
               return;
            }
            List<Message> history=state.props.elementAt(0);
            newMessage.add(mess);
            newMessage.addAll(history);

          } else if (state is LoadMorePeerMessageSuccess){
              FltImPlugin im = FltImPlugin();
              var res = await im.createConversion(
                currentUID: event.message['receiver'].toString(),
                peerUID: event.message['sender'].toString(),
              );
              cunrrentId=event.message['sender'].toString();
              Map response = await im.loadData();
              var  messages = ValueUtil.toArr(response["data"]).map((e) => Message.fromMap((e))).toList();

              newMessage.addAll(messages.reversed.toList());

          } else{
            FltImPlugin im = FltImPlugin();
            var res = await im.createConversion(
              currentUID: event.message['receiver'].toString(),
              peerUID: event.message['sender'].toString(),
            );
            Map response = await im.loadData();
            var  messages = ValueUtil.toArr(response["data"]).map((e) => Message.fromMap((e))).toList();

            newMessage.addAll(messages.reversed.toList());
          }


        yield PeerMessageSuccess(newMessage,cunrrentId);
      } catch (err) {
        print(err);
        yield GetPeerFailed();
      }

    }
    if (event is EventReceiveNewMessageAck) {

      try {

          String cunrrentId;
          List<Message> newMessage =[];
          FltImPlugin im = FltImPlugin();
          var res = await im.createConversion(
            currentUID: event.message['sender'].toString(),
            peerUID: event.message['receiver'].toString(),
          );
          cunrrentId=event.message['receiver'].toString();
          Map response = await im.loadData();
          var  messages = ValueUtil.toArr(response["data"]).map((e) => Message.fromMap((e))).toList();
          var newMessages= messages.map((item) {
            if(item.msgLocalID == event.message['msgLocalID']){
              item.flags=2;
              return item;
            }else{
              return item;
            }

          }).toList();

          newMessage.addAll(newMessages.reversed.toList());
        yield PeerMessageSuccess(newMessage,cunrrentId);
      } catch (err) {
        print(err);
        yield GetPeerFailed();
      }

    }

    if (event is EventFirstLoadMessage) {


      try {
        Map<String,dynamic> messageMap ={};
          FltImPlugin im = FltImPlugin();
          var res = await im.createConversion(
            currentUID: event.currentUID,
            peerUID: event.peerUID,
          );
          Map response = await im.loadData();
          var  messages = ValueUtil.toArr(response["data"]).map((e) => Message.fromMap(ValueUtil.toMap(e))).toList().reversed.toList();

        yield PeerMessageSuccess(messages,event.peerUID);
      } catch (err) {
        print(err);
        yield GetPeerFailed();
      }

    }
    if (event is EventLoadMoreMessage) {

      try {
           String LocalId ="0";
           List<Message> newMessages=[] ;
           FltImPlugin im = FltImPlugin();
           Map response;
           bool noMore =false;
          List<Message> history=[];
          if (state is PeerMessageSuccess){

            history=state.props.elementAt(0);
            LocalId= history.last.msgLocalID.toString();
            response = await im.loadEarlierData( messageID: LocalId);
          }else{

            if (state is LoadMorePeerMessageSuccess){

              history=state.props.elementAt(0);
              LocalId= history.last.msgLocalID.toString();
              response = await im.loadEarlierData( messageID: LocalId);
            }else{
              response = await im.loadData();
            }


          }

          var  messages = ValueUtil.toArr(response["data"]).map((e) => Message.fromMap(ValueUtil.toMap(e))).toList().reversed.toList();
          if (messages.length==0){
            noMore=true;
          }
          if(history.last!=null){
            newMessages.addAll(history);
            newMessages.addAll(messages);
          }else{

            newMessages.addAll(messages);
          }

        yield LoadMorePeerMessageSuccess(newMessages,noMore);
      } catch (err) {
        print(err);
        yield GetPeerFailed();
      }

    }
  }


}
