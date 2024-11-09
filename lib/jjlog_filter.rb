# frozen_string_literal: true

class JjlogFilter < Nanoc::Filter
  identifier :jjlog

  def run(content, params={})
    frag = Nokogiri::HTML5.fragment(content)

    frag.css("code.language-jjlog").each do |block|
      raise "?" unless block.children.count == 1
      text = block.text
      block.children.remove

      state = nil

      text.lines.each do |line|
        i = 0

        while line[i..][...2] == "│ "
          block << frag.document.create_text_node(line[i..][...2])
          i += 2
        end

        if line[i] == "@"
          state = :head
          block << frag.document.create_element("span", line[i]) { |n| n["class"] = "s bold" }
          i += 1
        elsif line[i] == "◆"
          state = :commit
          block << frag.document.create_element("span", line[i]) { |n| n["class"] = "nt" }
          i += 1
        elsif line[i] == "○"
          state = :commit
          block << frag.document.create_text_node(line[i])
          i += 1
        elsif line[i..] == "~\n" or line[i..] == "│\n"
          block << frag.document.create_text_node(line[i..])
          next
        elsif line[i..] == "~  (elided revisions)\n"
          block << frag.document.create_element("span", line[i..]) { |n| n["class"] = "cm" }
          next
        else
          state = (state == :head ? :head_desc : nil)
        end

        while " ├─╮╯".include?(line[i])
          block << frag.document.create_text_node(line[i])
          i += 1
        end

        if state == :head or state == :commit
          head_bold = (state == :head ? "bold" : "")
          
          # changeset id
          line[i..] =~ /\A([k-z]+)!([k-z]+) /
          i += $&.length
          block << frag.document.create_element("span", $1) { |n| n["class"] = "m bold" }
          block << frag.document.create_element("span", $2) { |n| n["class"] = "cm #{head_bold}" }
          block << frag.document.create_text_node(" ")
          
          # email
          line[i..] =~ /\A(\S+) /
          i += $&.length
          block << frag.document.create_element("span", $1) { |n| n["class"] = "nn #{head_bold}" } 
          block << frag.document.create_text_node(" ")

          # datetime
          line[i..] =~ /\A(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}) /
          i += $&.length
          block << frag.document.create_element("span", $1) { |n| n["class"] = "nt #{head_bold}" } 
          block << frag.document.create_text_node(" ")

          while line[i..] !~ /\A([0-9a-f]+)!([0-9a-f]+)\n/
            line[i..] =~ /\A(\S+) /
            i += $&.length

            klass = ($1 == "git_head()" ? "s" : "m #{head_bold}")
            block << frag.document.create_element("span", $1) { |n| n["class"] = klass } 
            block << frag.document.create_text_node(" ")
          end
            
          i += $&.length
          block << frag.document.create_element("span", $1) { |n| n["class"] = "kp bold" }
          block << frag.document.create_element("span", $2) { |n| n["class"] = "cm #{head_bold}" }
          block << frag.document.create_text_node("\n")
        elsif state == :head_desc
          block << frag.document.create_element("span", line[i..]) { |n| n["class"] = "s bold" }
        else
          block << frag.document.create_text_node(line[i..])
        end
      end
    end

    frag.to_s
  end

  private
end
