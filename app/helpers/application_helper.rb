module ApplicationHelper
	
	# Return a title on a per-page basis
	def title

		base_title = "University Centre Connect"
		if @title.nil?
			base_title
		else
			"#{base_title} | #{@title}"
	end
  

	end

#def logo
#    image_tag("logo.gif", :alt => "UCC logo", :class => "round")
#  end
end