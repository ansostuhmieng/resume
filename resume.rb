require 'prawn'

points_per_inch= 72
margin = 0.5 * points_per_inch

custom_size = [8.5 * points_per_inch, 11 * points_per_inch]
margins = [margin,margin,margin,margin]

heading_size = 35

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
     vertical_line 0 - margin, 10000, :at => 150
   end

   #draw background
   fill_gradient top_left, [150, 200], 'FF4500', 'CC0000'
   fill_rectangle top_left, page_width, 280

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
     font_size heading_size / 3
     fill_color "FFFFFF"
     move_down 20
     text "I am a vision led project manager who excels at taking customer requirements and turning them into easy to use deliverables.  I have experience in the full stack of windows based software-as-a-service world, including but not limited to: database management and design, web-service design, user-interface design, system deployment, IIS configuration and management, domain configuration, email systems, automated reporting systems, security reviews, system documentation, and more.  My passion is to deliver front-end experiences that exceed customer and industry expectations.", :leading => 5
   end

   move_down 70
   #change text color to black
   fill_color "888888"

   save_cursor = cursor
   font_size heading_size / 2.5
   text "skills"

   File.open("skills.md") do |infile|
    while(line = infile.gets)
      line = line.strip!.scan(/[[:print:]]/).join
			line.gsub!(/\s+/,' ')

      #skip blank lines
      if line.length == 0
        next
      end

      if(line.index("*") ==0)
       font_size heading_size / 2.5
       fill_color "000000"
       line.sub!('* ','')
       text_box line, :at => [175,save_cursor]
      else
        font_size heading_size / 3
        fill_color "888888"
        line.sub!(': ','')
        text_box line,
         :at => [175, save_cursor - 15]
        save_cursor -= 50
      end
    end

    move_cursor_to save_cursor - 10
    font_size heading_size / 2.5
    text "techinical"
    move_up height_of("technical")

    position = 0
    bounding_box([175, cursor], :width => 300) do

      File.open("technical.md") do |infile|
       while(line = infile.gets)
         line = line.strip!.scan(/[[:print:]]/).join
    			 line.gsub!(/\s+/,' ')

        #skip blank lines
        if line.length == 0
          next
        end

        font_size heading_size / 3
        fill_color "000000"
        line.sub!('1. ','')
        text_box line, :at => [110 * position,cursor], :width => 100

        position += 1
        if(position >= 3)

          position = 0
          move_down height_of(line)

          stroke do
            stroke_color "DDDDDD"
            horizontal_line 0, 400, :at => 0
          end

          move_down 5

        end

       end
     end
   end

   #change text color to black
   fill_color "888888"


   move_down 20
   save_cursor = cursor
   font_size heading_size / 2.5
   text "experience"

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
       font_size heading_size / 2.5
       fill_color "000000"
       line.sub!('* ','')
       text_box line, :at => [175,save_cursor]
       year_cursor = save_cursor
     elsif(line.index("__") == 0)
        font_size heading_size / 3
        fill_color "555555"
        line.gsub!('__','')
        text_box line,
         :at => [175, year_cursor],
         :align => :right
      elsif(line.index(": ") == 0)
        font_size heading_size / 3
        fill_color "333333"
        line.sub!(': ','')
        text_box line,
         :at => [175, save_cursor - 15]
        save_cursor -= height_of(line)
      else
        font_size heading_size / 3.5
        fill_color "888888"
        line.sub!(': ','')
        text_box line,
         :at => [175, save_cursor - 15]
         save_cursor -= height_of(line, {:at=>[175, save_cursor - 15]}) + 10
      end
    end
  end


  #change text color to black
  start_new_page

  stroke do
    stroke_color "DDDDDD"
    vertical_line 0 - margin, 10000, :at => 150
  end

  fill_color "888888"

  save_cursor = cursor
  font_size heading_size / 2.5
  text "projects"

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
      font_size heading_size / 2.5
      fill_color "000000"
      line.sub!('* ','')
      text_box line, :at => [175,save_cursor]
      year_cursor = save_cursor
    elsif(line.index("__") == 0)
       font_size heading_size / 3
       fill_color "555555"
       line.gsub!('__','')
       text_box line,
        :at => [175, year_cursor],
        :align => :right
     elsif(line.index(": ") == 0)
       font_size heading_size / 3
       fill_color "333333"
       line.sub!(': ','')
       text_box line,
        :at => [175, save_cursor - 15]
       save_cursor -= height_of(line)
     else
       font_size heading_size / 3.5
       fill_color "888888"
       line.sub!(': ','')
       text_box line,
        :at => [175, save_cursor - 15]
       save_cursor -= height_of(line, {:at=>[175, save_cursor - 15]}) + 10
     end
   end
 end


 fill_color "888888"

 move_cursor_to save_cursor
 move_down 20

 save_cursor = cursor
 font_size heading_size / 2.5
 text "education"

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
     font_size heading_size / 2.5
     fill_color "000000"
     line.sub!('* ','')
     text_box line, :at => [175,save_cursor]
     year_cursor = save_cursor
   elsif(line.index("__") == 0)
      font_size heading_size / 3
      fill_color "555555"
      line.gsub!('__','')
      text_box line,
       :at => [175, year_cursor],
       :align => :right
    elsif(line.index(": ") == 0)
      font_size heading_size / 3
      fill_color "333333"
      line.sub!(': ','')
      text_box line,
       :at => [175, save_cursor - 15]
      save_cursor -= height_of(line)
    else
      font_size heading_size / 3.5
      fill_color "888888"
      line.sub!(': ','')
      text_box line,
       :at => [175, save_cursor - 15]
      save_cursor -= height_of(line) + 20
    end
  end
end




  end

 end
