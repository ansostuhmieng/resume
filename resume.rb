require 'prawn'

points_per_inch= 72
margin = 1 * points_per_inch

custom_size = [8.5 * points_per_inch, 11 * points_per_inch]
margins = [margin,margin,margin,margin]

heading_size = 35
detail_heading_size = 12
detail_subheading_size = 10
detail_text_size = 8

vertical_line = 75
right_side_content_offset = 100

output_file = "ruby_resume.pdf"

name = "Andrew Rodman"
title = "lead developer, system architect"
phone = "206.355.7484"
email = "arodman@gmail.com"

background_color = 'blue'

signature_font = "signature";

metadata = {
 :Title => "Resume of Andrew Rodman",
 :Author => "Andrew Rodman",
 :Subject => "Resume",
 :Keywords => "lead developer, system architect",
 :Creator => "Andrew Rodman",
 #:Producer => "Prawn",
 :CreationDate => Time.now
 }

if(File.exist?(output_file))
  File.delete(output_file)
end

top_left = [0 - margin, 11 * points_per_inch]
page_width = 8.5 * points_per_inch

 Prawn::Document.generate(output_file, :page_size=>custom_size, :margin => margins, :info => metadata) do
   nbsp = Prawn::Text::NBSP

   font_families.update("signature" => {
    :normal => "chantil.ttf"
   })

   save_cursor = cursor

   stroke do
     stroke_color "DDDDDD"
     vertical_line 0 - margin, 10000, :at => vertical_line
   end

   #draw background
   fill_gradient top_left, [150, 200], 'FF4500', 'CC0000'
   fill_rectangle top_left, page_width, 350

   #reset text color to white
   fill_color "FFFFFF"

   #output contact information heading
   move_cursor_to save_cursor
   text phone, :align => :right
   text email, :align => :right

   #move cursor to top, output main header
   move_cursor_to save_cursor

   font_size heading_size
   text name

   transparent(0.4) do
     move_up 10
     fill_color "FFFFFF"
     font_size heading_size / 2
     text title
   end

   #move_down 20
   #stroke_horizontal_rule

   transparent(0.1) do
     font_size heading_size/1.25
     fill_color "FFFFFF"
     #font signature_font

     text "who am i?   ", :align => :right
     move_up 35
   end

   #font "Helvetica"

   transparent(0.8) do
     font_size heading_size /3
     fill_color "FFFFFF"
     move_down 20
     text "I am a vision led project manager who excels at taking customer requirements and turning them into easy to use deliverables.  I have experience in the full stack of windows based software-as-a-service world, including but not limited to: database management and design, web-service design, user-interface design, system deployment, IIS configuration and management, domain configuration, email systems, automated reporting systems, security reviews, system documentation, and more.  My passion is to deliver front-end experiences that exceed customer and industry expectations.", :leading => 2
   end

   move_down 70
   #change text color to black
   fill_color "888888"

   save_cursor = cursor
   font_size detail_heading_size
   text "skills"

   transparent(0.05) do

     move_up 36
     image "png/computer screen14.png", :width => 144, :height => 144, :position => -100

   end

   move_cursor_to save_cursor

   File.open("skills.md") do |infile|
    while(line = infile.gets)
      line = line.strip!.scan(/[[:print:]]/).join
			line.gsub!(/\s+/,' ')

      #skip blank lines
      if line.length == 0
        next
      end

      if(line.index("*") ==0)
       font_size detail_heading_size
       fill_color "000000"
       line.sub!('* ','')
       text_box line, :at => [right_side_content_offset,save_cursor]
      else
        font_size detail_subheading_size
        fill_color "888888"
        line.sub!(': ','')
        text_box line,
         :at => [right_side_content_offset, save_cursor - 15]
        save_cursor -= 50
      end
    end

    move_cursor_to save_cursor - 10
    font_size detail_heading_size
    text "techinical"
    move_up height_of("technical")

    save_cursor = cursor
    last_height = 0

    position = 0
    bounding_box([right_side_content_offset, cursor], :width => 400) do

      File.open("technical.md") do |infile|
       while(line = infile.gets)
         line = line.strip!.scan(/[[:print:]]/).join
    			 line.gsub!(/\s+/,' ')

        #skip blank lines
        if line.length == 0
          next
        end

        font_size detail_subheading_size
        fill_color "000000"
        line.sub!('1. ','')
        text_box line, :at => [120 * position,cursor], :width => 110
        local_height = height_of(line, {:at=>[120 * position, cursor]})

        position += 1
        last_height = [last_height, local_height].max

        if(position >= 3)

          position = 0
          move_down last_height

          stroke do
            stroke_color "DDDDDD"
            horizontal_line 0, 600, :at => 0
          end

          move_down 5

          last_height = 0
        end

       end
     end
   end

   #change text color to black
   fill_color "888888"


   move_down 20
   save_cursor = cursor
   font_size detail_heading_size
   text "experience"

   transparent(0.05) do

     move_up 36
     image "png/worker39.png", :width => 144, :height => 144, :position => -100

   end

   move_cursor_to save_cursor

   year_cursor = save_cursor

   File.open("experience.md") do |infile|
    while(line = infile.gets)
      line = line.strip!.scan(/[[:print:]]/).join
      line.gsub!(/\s+/,' ')

      #skip blank lines
      if line.length == 0
        save_cursor -= 15
        next
      end

      if(line.index("*") ==0)
       font_size detail_heading_size
       fill_color "000000"
       line.sub!('* ','')
       text_box line, :at => [right_side_content_offset,save_cursor]
       year_cursor = save_cursor
     elsif(line.index("__") == 0)
        font_size detail_subheading_size
        fill_color "555555"
        line.gsub!('__','')
        text_box line,
         :at => [right_side_content_offset, year_cursor],
         :align => :right
      elsif(line.index(": ") == 0)
        font_size detail_subheading_size
        fill_color "333333"
        line.sub!(': ','')
        text_box line,
         :at => [right_side_content_offset, save_cursor - 15]
        save_cursor -= height_of(line, {:at=>[right_side_content_offset, save_cursor - 15]})
      else
        font_size detail_text_size
        fill_color "888888"
        line.sub!(': ','')
        text_box line,
         :at => [right_side_content_offset, save_cursor - 15]
         save_cursor -= height_of(line, {:at=>[right_side_content_offset, save_cursor - 15]}) + 10
      end
    end
  end


  #change text color to black
  start_new_page

  stroke do
    stroke_color "DDDDDD"
    vertical_line 0 - margin, 10000, :at => vertical_line
  end

  fill_color "888888"

  save_cursor = cursor
  font_size detail_heading_size
  text "projects"


   transparent(0.05) do

     move_up 36
     image "png/cogwheels12.png", :width => 144, :height => 144, :position => -100

   end

   move_cursor_to save_cursor


  year_cursor = save_cursor

  File.open("projects.md") do |infile|
   while(line = infile.gets)
     line = line.strip!.scan(/[[:print:]]/).join
     line.gsub!(/\s+/,' ')

     #skip blank lines
     if line.length == 0
       save_cursor -= 15
       next
     end

     if(line.index("*") ==0)
      font_size detail_heading_size
      fill_color "000000"
      line.sub!('* ','')
      text_box line, :at => [right_side_content_offset,save_cursor]
      year_cursor = save_cursor
    elsif(line.index("__") == 0)
       font_size detail_subheading_size
       fill_color "555555"
       line.gsub!('__','')
       text_box line,
        :at => [right_side_content_offset, year_cursor],
        :align => :right
     elsif(line.index(": ") == 0)
       font_size detail_subheading_size
       fill_color "333333"
       line.sub!(': ','')
       text_box line,
        :at => [right_side_content_offset, save_cursor - 15]
       save_cursor -= height_of(line, {:at=>[right_side_content_offset, save_cursor - 15]})
     else
       font_size detail_text_size
       fill_color "888888"
       line.sub!(': ','')
       text_box line,
        :at => [right_side_content_offset, save_cursor - 15]
       save_cursor -= height_of(line, {:at=>[right_side_content_offset, save_cursor - 15]}) + 10
     end
   end
 end


 fill_color "888888"

 move_cursor_to save_cursor
 move_down 20

 save_cursor = cursor
 font_size detail_heading_size
 text "education"

 transparent(0.05) do

   move_up 36
   image "png/Graduate_student_avatar_512.png", :width => 144, :height => 144, :position => -100

 end

 move_cursor_to save_cursor

 year_cursor = save_cursor

 File.open("education.md") do |infile|
  while(line = infile.gets)
    line = line.strip!.scan(/[[:print:]]/).join
    line.gsub!(/\s+/,' ')

    #skip blank lines
    if line.length == 0
      save_cursor -= 15
      next
    end

    if(line.index("*") ==0)
     font_size detail_heading_size
     fill_color "000000"
     line.sub!('* ','')
     text_box line, :at => [right_side_content_offset,save_cursor]
     year_cursor = save_cursor
   elsif(line.index("__") == 0)
      font_size detail_subheading_size
      fill_color "555555"
      line.gsub!('__','')
      text_box line,
       :at => [right_side_content_offset, year_cursor],
       :align => :right
    elsif(line.index(": ") == 0)
      font_size detail_subheading_size
      fill_color "333333"
      line.sub!(': ','')
      text_box line,
       :at => [right_side_content_offset, save_cursor - 15]
      save_cursor -= height_of(line)
    else
      font_size detail_text_size
      fill_color "888888"
      line.sub!(': ','')
      text_box line,
       :at => [right_side_content_offset, save_cursor - 15]
      save_cursor -= height_of(line) + 20
    end
  end
end




  end

 end
