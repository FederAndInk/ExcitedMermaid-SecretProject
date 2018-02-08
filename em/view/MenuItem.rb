class MenuItem
  HOVER_OFFSET = 3
      def initialize (window, image, x, y, z, callback,text, hover_image = nil, options = false)
          @window = window
          @main_image = image
          @hover_image = hover_image
          @original_x = @x = x
          @original_y = @y = y
          @z = z
          @callback = callback
          @active_image = @main_image
          @text = text
          
          @xMod = 0.05
          @yMod = 0.05
          
          @options = options
      end
  
      def draw(x= 0.05, y=0.05)
          @xMod = x
          @yMod = y
          @textImage = Gosu::Image.from_text(@text,50, {:align => :center})
          @active_image.draw(@x, @y, @z, @xMod, @yMod)
          if @options
            @textImage.draw((@x-@textImage.width/2)+200, @y+75, @z, 1, 1,  0xff_e43b44)
          else
            @textImage.draw((@x-@textImage.width/2)+100, @y+25, @z, 1, 1,  0xff_e43b44)
          end
      end
      
      def setText(text)
        @text = text
        puts(@text)
      end
  
      def update
          if is_mouse_hovering then
              if !@hover_image.nil? then
                  @active_image = @hover_image
              end
  
              @x = @original_x + HOVER_OFFSET
              @y = @original_y + HOVER_OFFSET
          else 
              @active_image = @main_image
              @x = @original_x
              @y = @original_y
          end
#          puts(@text)
#          draw
      end
  
      def is_mouse_hovering
          mx = @window.mouse_x
          my = @window.mouse_y
  
          (mx >= @x and my >= @y) and (mx <= @x + @active_image.width*@xMod) and (my <= @y + @active_image.height*@yMod)
#          puts("a = "+"#{@x}")
#          puts("b = "+"#{@x + @active_image.width*0.05}")
#          puts("c = "+"#{@y}")
#          puts("d = "+"#{@y + @active_image.height*0.05}")
      end
  
      def clicked
          if is_mouse_hovering then
              @callback.call
          end
      end
end