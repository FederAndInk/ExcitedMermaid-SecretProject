class Menu
  def initialize (window)
          @window = window
          @items = Array.new
      end
  
      def add_item (image, x, y, z, callback,text , hover_image = nil)
          item = MenuItem.new(@window, image, x, y, z, callback,text, hover_image)
          @items << item
          self
      end
      
      def clean
        @items.clear()
      end
  
      def draw
          @items.each do |i|
              i.draw
          end
      end
      
      def setText(text)
        @items[0].setText(text)
      end
      
       def isEmpty
         return @items.empty?()
       end
  
      def update
          @items.each do |i|
              i.update
          end
      end
  
      def clicked
          @items.each do |i|
              i.clicked
          end
      end
end