# PositionMover is a module to manage the :position
# attribute of a model.
# Put in the "/lib" folder and include it in any class 
# (with a :position column) using "include PositionMover".
# NB: Plug-ins such as "acts_as_list" offer additional 
# functionality and better performance.
module PositionMover
  
  # <tt>move_to_position</tt> is an instance method that 
  # will move a list item to a new position, but also 
  # increment/decrement the positions of the other list items
  # as necessary.
  # 
  # Send nil as the value for new_position to remove 
  # the item from the list.
  def move_to_position(new_position)
    max_position = self.class.where(position_scope).count
    # ensure new_position is an integer in 1..max_position
    unless new_position.nil?
      new_position = [[1, new_position.to_i].max, max_position].min
    end
    
    if position == new_position # do nothing
      return true
    elsif position.nil? # not in list yet
      increment_items(new_position, 1000000)
    elsif new_position.nil? # remove from list
      decrement_items(position+1, 1000000)
    elsif new_position < position # shift lower items up
      increment_items(new_position, position-1)
    elsif new_position > position # shift higher items down
      decrement_items(position+1, new_position)
    end
    return update_attribute(:position, new_position)
  end
  
  private
  
  # <tt>position_scope</tt> defines an SQL fragment used for 
  # narrowing the scope of queries related to position.
  #
  # Often it is not desirable to manage positions for all items 
  # in a class, but instead to narrow the scope based on a 
  # parent class. For example, if subject1 has 3 pages and
  # subject2 has 4 pages, you would want to narrow the scope of 
  # position so that when working with subject1's pages only 
  # positions 1-3 under that subject are reordered. The positions
  # of subject2's pages should be unchanged. And each subject 
  # should be able to have a page at position 1.
  #
  # To narrow the scope, override this method in your model 
  # with the SQL that should be used to narrow the scope. 
  # (NB: Must come after "include PositionMover".)
  # 
  # Example:
  # class Page < ActiveRecord::Base
  #   include PositionMover
  #   def position_scope
  #     "pages.subject_id = #{subject_id.to_i}"
  #   end
  # end
  def position_scope
    # default is always true
    # won't affect SQL conditions or narrow scope
    "1=1"
  end
  
  def increment_items(first, last)
    items = self.class.where(["position >= ? AND position <= ? AND #{position_scope}", first, last])
    items.each {|i| i.update_attribute(:position, i.position + 1) }
  end

  def decrement_items(first, last)
    items = self.class.where(["position >= ? AND position <= ? AND #{position_scope}", first, last])
    items.each {|i| i.update_attribute(:position, i.position - 1) }
  end
  
end
