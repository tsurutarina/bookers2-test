class ChatsController < ApplicationController
  def show
    #相手の情報取得
    @user = User.find(params[:id])
    # user_roomsテーブルのuser_idが自分のoom_idレコードを配列で取得
    rooms = current_user.user_rooms.plick(:room_id)
    # user_idが相手、room_idが自分の属するroom_id(配列)となるuser_roomsテーブルのレコードを取得して、user_room変数に格納
    # これによって、自分と相手に共通room_idがあれば、そのroom_idと相手user_idがuser_room変数に格納される。存在してなければnil。
    user_room = UserRoom.find_by(user_id: @user.id, room_id: rooms)

    # user_roomでルーム取得できなかった（ルームまだない）
    room = nil
    if user_room.nil?
      # roomのid採番
      room = Room.new
      room.save
      # 採番したroomのidを使って、二人共通のuser_roomのレコードを作る
      # 相手用 user.idとroom.idをUserRoomモデルのカラムに保存
      UserRoom.create(user_id: user.id, room_id: room.id)
      # 自分用
      UserRoom.create(user_id: current_user.id, room_id: room.id)
    else
      # user_roomに紐づくroomsテーブルのレコードをroomに格納
      room = user_room.room
    end

    @chats = room.chats

    @chat = Chat.new(room_id: room.id)
  end

  def create
    @chat = current_user.chats.new(chat_params)
    @chat.save
  end


  private
  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end
end
