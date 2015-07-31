class TestimonialsController < ApplicationController
  def index
    @search  = Testimonial.active.position
    @testimonials = @search.paginate(:page => params[:page], :per_page => 18)
    column_1_size = (@testimonials.length / 3) + ((@testimonials.length % 3 > 0) ? 1 : 0)
    column_2_size = (@testimonials.length / 3) + ((@testimonials.length % 3 > 1) ? 1 : 0)
    column_3_size = (@testimonials.length / 3)
    @testimonials_1 = @testimonials[0..(column_1_size - 1)]
    @testimonials_2 = @testimonials[column_1_size..(column_1_size + column_2_size - 1)]
    @testimonials_3 = @testimonials[(column_1_size + column_2_size)..(column_1_size + column_2_size + column_3_size - 1)]
  end  
  
  def show
    redirect_to :action => "index"
  end
  
end
