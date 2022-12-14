class Inboxes::MessagesController < ApplicationController
  before_action :set_inbox

  def change_status
    @message = @inbox.messages.find(params[:id])
    @message.update(status: params[:status])
    flash[:notice] = "Status changed to #{@message.status}"
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          render_turbo_flash,
          turbo_stream.replace(@message,
                               partial: 'inboxes/messages/message',
                               locals: { message: @message })
        ]
      end
    end
  end

  def upvote
    @message = @inbox.messages.find(params[:id])
    flash[:notice] = 'voted!'
    @message.upvote! current_user
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          render_turbo_flash,
          turbo_stream.replace(@message,
                               partial: 'inboxes/messages/message',
                               locals: { message: @message })
        ]
      end
    end
  end

  def create
    @message = @inbox.messages.new(message_params)
    respond_to do |format|
      if @message.save
        format.turbo_stream do
          flash.now[:notice] = "Message #{@message.body} created!!"
          render turbo_stream: [
            render_turbo_flash,
            turbo_stream.update('new_message',
                                partial: 'inboxes/messages/form',
                                locals: { message: Message.new }),
            turbo_stream.update('message_counter', @inbox.messages_count),
            turbo_stream.prepend('message_list',
                                 partial: 'inboxes/messages/message',
                                 locals: { message: @message })
          ]
        end
        format.html { redirect_to @inbox }
      else
        format.turbo_stream do
          flash.now[:alert] = 'Somthing worng!!'
          render turbo_stream: [
            render_turbo_flash,
            turbo_stream.update('new_message',
                                partial: 'inboxes/messages/form',
                                locals: { message: @message })
          ]
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end
  end

  def destroy
    @message = @inbox.messages.find(params[:id])
    @message.destroy
    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = "Message #{@message.body} destroyed !!"
        render turbo_stream: [
          render_turbo_flash,
          turbo_stream.remove(@message),
          turbo_stream.update('message_counter', @inbox.messages_count)
        ]
      end
      format.html { redirect_to @inbox }
    end
  end

  private

  def render_turbo_flash
    turbo_stream.update('flash', partial: 'shared/flash')
  end

  def set_inbox
    @inbox = Inbox.find(params[:inbox_id])
  end

  def message_params
    params.require(:message).permit(:body).merge(user: current_user)
  end
end
