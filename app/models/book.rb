class Book < ApplicationRecord
	has_attached_file :cover_image, styles: { medium: "10x30>", thumb: "10x10>" }, default_url: "/images/:style/missing.png"
	validates_attachment_content_type :cover_image, content_type: /\Aimage\/.*\z/

	def cover_image_url
		self.cover_image.url
	end
end
