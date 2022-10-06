class ChatsController < ApplicationController
  before_action :reject_non_related, only: [:show]
  
  def show
    #相手の情報取得
    @user = User.find(params[:id])
    # user_roomsテーブルのuser_idが自分のoom_idレコードを配列で取得
    rooms = current_user.user_rooms.pluck(:room_id)
    # user_idが相手、room_idが自分の属するroom_id(配列)となるuser_roomsテーブルのレコードを取得して、user_room変数に格納
    # これによって、自分と相手に共通room_idがあれば、そのroom_idと相手user_idがuser_room変数に格納される。存在してなければnil。
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms)

    # user_roomでルーム取得できなかった（ルームまだない）
    unless user_rooms.nil?
      @room = user_rooms.room
    else
      # roomのid採番
      @room = Room.new
      @room.save
      # 採番したroomのidを使って、二人共通のuser_roomのレコードを作る
      # 相手用 user.idとroom.idをUserRoomモデルのカラムに保存
      UserRoom.create(user_id: @user.id, room_id: @room.id)
      # 自分用
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
    end

    #roomに紐づくchatsテーブルのレコードをchatに格納
    @chats = @room.chats
    # form_withでチャット送信するための空インスタンス
    # room.idを@chatに代入しないと、form_withで記述するroom.idに値が渡らない
    @chat = Chat.new(room_id: @room.id)
  end

  def create
    @chat = current_user.chats.new(chat_params)
    @chat.save
  end


  private
  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end

  def reject_non_related
    user = User.find(params[:id])
    unless current_user.following?(user) && user.following?(current_user)
      redirect_to books_path
    end
  end
end
