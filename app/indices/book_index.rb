ThinkingSphinx::Index.define :book, :with => :active_record do
	indexes title
	indexes author
	indexes description
end