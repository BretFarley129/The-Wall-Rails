class WallsController < ApplicationController
  def index
    redirect_to '/users/new'
  end

  def new
    @errors = flash[:errors]
  end
  
  def newUser
    exist = User.find_by(user_params)
    if exist
      puts "~~~~~~~~~~~~~~~~~~~~~~"
      puts exist.username
      session[:username] = exist.username
      redirect_to '/messages'
    else
      user = User.new(user_params)
      if user.valid?
        session[:username] = user.username
        user.save
        redirect_to '/messages'
      else
        flash[:errors] = user.errors
        redirect_to :back
      end
    end
  end
  
  def messages
    @messages = Message.includes(:comments).all
    @username = session[:username]
    @errors = flash[:errors]
  end

  def newMessage
    message = Message.new(message_params)
    user = User.find_by(username: session[:username])
    message.user = user
    if message.valid?
      message.save
      puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      puts "message is valid"
      redirect_to :back
    else
      puts "##########################"
      puts "message is invalid"
      flash[:errors] = message.errors
      redirect_to :back
    end
  end

  def newComment
    comment = Comment.new(comment_params)
    message = Message.find(params[:id])
    user = User.find_by(username: session[:username])
    comment.user = user
    comment.message = message
    if comment.valid?
      comment.save
      puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      puts "comment is valid"
      redirect_to :back
    else
      puts "##########################"
      puts "comment is invalid"
      flash[:errors] = comment.errors
      redirect_to :back
    end

  end

  def logout
    session[:username] = nil
    redirect_to '/users/new'
  end
  
  private
  def user_params
    params.require(:user).permit(:username)
  end
  def message_params
    params.require(:message).permit(:message)
  end
  def comment_params
    params.require(:comment).permit(:comment)
  end
end
