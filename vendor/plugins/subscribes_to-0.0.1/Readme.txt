subscribes_to is used currently to associate individual pages content with various
models. These models must be taggable otherwise you cannot subscribe to them.


--USE--

In the PageContent model include the line;
  subscribes_to :layout1 => [Model1, Model2, Model3...],
                :layout2 => [Model4, Model5...],
                    .
                    .
                    .

The models (Model1, Model2, etc.) can be input as arrays specifying the symbol
representation of what they are acting as taggable on such as [Product, :categories]

For example;
  subscribes_to :basic => [Article, Product],
                :complex => [Article, BlogEntry, [Testimonial, :services], CaseStudy],
                :staff => [[Testimonial, :services]]

where basic, complex and staff are page_contents layouts. If you have layouts that
don't need to subscribe they don't need to be listed.

In views/admin/page_contents/_layout.html.erb include the line;
  <%= f.subscription_select %>
  
to be able to choose which tags to subscribe to when editing a page.

The line;
  params[:page_node][:page_contents_attributes]["0"][:tag_subscribe_array] ||= []
  
needs to be added to the update method of the page nodes controller for technical reasons.

In order to call a page content's subscriptions for use on the front end call .subscriptions.

