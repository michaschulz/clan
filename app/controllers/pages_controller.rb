class PagesController < ApplicationController
	before_filter :authenticate_user! 
	before_filter :find_subject
	load_and_authorize_resource
  
  def index
    list
    render('list')
  end
  
  def list
    @pages = Page.sorted.where(:subject_id => @subject.id)
  end
  
  def show
    @page = Page.find(params[:id])
  end
  
  def new
    @page = Page.new(:subject_id => @subject.id)
    @page_count = @subject.pages.size + 1
    @subjects = Subject.order('position ASC')
  end
  
  def create
    new_position = params[:page].delete(:position)
    # Instantiate a new object using form parameters
    @page = Page.new(params[:page])
    # Save the object
    if @page.save
      @page.move_to_position(new_position)
      # If save succeeds, redirect to the list action
      flash[:notice] = "Seite erstellt."
      redirect_to(:action => 'list', :subject_id => @page.subject_id)
    else
      # If save fails, redisplay the form so user can fix problems
      @page_count = @subject.pages.size + 1
      @subjects = Subject.order('position ASC')
      render('new')
    end
  end
  
  def edit
    @page = Page.find(params[:id])
    @page_count = @subject.pages.size
    @subjects = Subject.order('position ASC')
  end
  
  def update
    new_position = params[:page].delete(:position)
    # Find object using form parameters
    @page = Page.find(params[:id])
    # Update the object
    if @page.update_attributes(params[:page])
      @page.move_to_position(new_position)
      # If update succeeds, redirect to the list action
      flash[:notice] = "Seite geändert."
      redirect_to(:action => 'list', :id => @page.id, :subject_id => @page.subject_id)
    else
      # If save fails, redisplay the form so user can fix problems
      @page_count = @subject.pages.size
      @subjects = Subject.order('position ASC')
      render('edit')
    end
  end
  
  def delete
    @page = Page.find(params[:id])
  end
  
  def destroy
    page = Page.find(params[:id])
    page.move_to_position(nil)
    page.destroy
    flash[:notice] = "Seite gelöscht."
    redirect_to(:action => 'list', :subject_id => @subject.id)
  end
  
  private
  
  def find_subject
    if params[:subject_id]
      @subject = Subject.find_by_id(params[:subject_id])
    end
  end
    
end
