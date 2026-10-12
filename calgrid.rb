
#
# calgrid.rb

require 'time'

numbers = ARGV.select { |a| a.match?(/^\d+$/) }.map(&:to_i)
year = numbers.find { |n| n > 2025 } || Time.now.year

month = numbers.find { |n| n > 0 && n < 13 } || Time.now.month + 1
month = 1 if month > 12

grey = '#777777'
lightgrey = '#bbbbbb'

w = 15.5 # width in cm approx
side = 0.70
cols = (w.to_f / side).to_i + 1
sqc = cols - 3

t = Time.parse("#{year}-#{month}-1 12:00")

puts "<!DOCTYPE html>"
puts "<html>"
puts "<head>"
puts "<title>ruler - #{t.strftime('%Y %B')}</title>"
puts %{
<style>
  html, body {
      width: 100%;
      max-width: 100%;
      overflow-x: hidden;
      margin: 0;
      padding: 0;
  }
  body {
    font-family: monospace;
    font-size: 11pt;
    margin: 0 auto;
    /*
    width: 14cm;
    */
  }
  table {
    table-layout: fixed;
    border-collapse: collapse;
    td {
      box-sizing: border-box;
      height:     #{side}cm;
      min-height: #{side}cm;
      max-height: #{side}cm;
      border: 1px dotted #{lightgrey};
      padding-left: 3px;
    }
    td.wday { width: #{1.4 * side}cm; }
    td.mday { width: #{side}cm; }
    td.sq {
      width: #{side}cm;
      min-width: #{side}cm;
      max-width: #{side}cm;
    }
    td.wn {
      width: #{1.3 * side}cm;
      min-width: #{1.3 * side}cm;
    }
    td.sunday { border-bottom: 1px solid #{grey}; }
    .title { font-weight: bold; }
  }
</style>
  }.strip
puts "</head>"

puts "<body>"

#puts "<h1>#{t.strftime('%Y %B')}</h1>"

puts "<table>"

#puts "<thead>"
#print '<tr>'
#print '<th class="wday"></th>'
#print '<th class="mday"></th>'
#sqc.times { print "<th class='sq'></th>" }
#puts '</tr>'
#puts "</thead>"

puts "<tbody>"

print "<tr>"
print "<td class='title' colspan='#{sqc + 2}'>#{t.strftime('%Y %B')}</td>"
#sqc.times { print "<td class='sq'></td>" }
puts "</tr>"

print "<tr>"
print "<td class='wday'></td>"
print "<td class='mday'></td>"
print "<td class='sq'></td>"
(sqc - 1).times { |i| print "<td class='sq'>#{'%02d' % (5 + i)}</td>" }
puts "</tr>"

2.times do
  print "<tr>"
  print "<td class='wday'></td>"
  print "<td class='mday'></td>"
  sqc.times { print "<td class='sq'></td>" }
  puts "</tr>"
end

(1..31).each do |d|
  t = Time.parse("#{year}-#{month}-#{d} 12:00")
  break if t.month != month
  wd = t.strftime('%A').downcase
  print "<tr>"
  print "<td class='wday #{wd}'>#{t.strftime('%a')}</td>"
  print "<td class='mday #{wd}'>#{t.strftime('%d')}</td>"

  wn = t.wday == 1 ? "w#{t.strftime('%W').to_i + 1}" : ''
  print "<td class='sq #{wd} wn'>#{wn}</td>"

  (sqc - 1).times { print "<td class='sq #{wd}'></td>" }

  puts "</tr>"
end

puts "</tbody>"
puts "</table>"

puts "</body>"
puts "</html>"

