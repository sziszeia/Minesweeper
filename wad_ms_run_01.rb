# Ruby code file - All your code should be located between the comments provided.

# Add any additional gems and global variables here
require 'sinatra'

# The file where you are to write code to pass the tests must be present in the same folder.
# See http://rspec.codeschool.com/levels/1 for help about RSpec
require "#{File.dirname(__FILE__)}/wad_ms_gen_01"

# Main program
module MS_Game
	@input = STDIN
	@output = STDOUT
	g = Game.new(@input, @output)
	$webgame = g
	playing = true
	input = ""
	option = 0
	turn = 0
	placed = nil
		
	@output.puts 'Enter "1" runs game in command-line window or "2" runs it in web browser.'
	game = g.getinput
	if game == "1"
		@output.puts "Command line game"
	elsif game == "2"
		@output.puts "Web-based game"
	else
		@output.puts "Invalid input! No game selected."
		exit
	end
		
	if game == "1"
		
	# Any code added to command line game should be added below.
	
	 g.start
	 g.getinput

	 while playing do
		system "cls"
		
		# Display initial message for users
		g.initialgamemessage

		userselection = g.getinput.to_i

			# Until user selects 9 roll on playing
			until userselection == 9 do

				# Ensure user only inputs a valid option
				unless (userselection == 1 || userselection == 2 || userselection == 9)
					@output.puts "Invalid selection, please amend your selection to a valid option."
					userselection = g.getinput.to_i
					next
				end
			
				# if user selects resume game check if a game is set up by checking if any players are set
				if userselection == 1
					if !g.getplayer1
						system "cls"
						@output.puts g.nogametoresumemessage
						g.displaymenu
						userselection = g.getinput.to_i
						next
					else
						# if user is set just create new game for current players
						winner = 0
						g.resetscores
						@totalminesremaining = @maxtotalmines
						g.startgame
					end
				end

				# If user selects a new game then set up a new game
				if userselection == 2
					@output.puts g.setupmessage
					@output.puts g.promptforplayer1sname
					player1 = g.getinput
					@output.puts g.promptforplayer2sname
					player2 = g.getinput
					g.initialgamesetup(player1, player2)
					@output.puts g.getnewgamecreated
				end
				
				g.startgame
				system "cls"

				g.displaymenu
				userselection = g.getinput.to_i
			end

			@output.puts "Thanks for playing, see you soon."
			g.getinput
			playing = false
	 end
	
	# Any code added to output the activity messages to the command line window should be added above.

		exit	# Does not allow command-line game to run code below relating to web-based version
	end
end
# End modules

# Sinatra routes

	# Any code added to output the activity messages to a browser should be added below.
	get '/' do
		@message = $webgame.initialgamemessage
		@createdby = $webgame.created_by + " - " + $webgame.student_id.to_s
		erb :index
	end

	get '/gamearena' do
		$webgame.resetscores

		# Clear the game field
		$webgame.clearcolumns
						
		# Set and place mines on game board
		#$webgame.generateandplacemines

		@gamearea = $webgame.displaycurrentframe
		erb :gamearena
	end

	get '/about' do
		@rules = $webgame.explain_rules
		erb :about
	end

	get '/quit' do
		erb :goodbyepage
	end


	# Any code added to output the activity messages to a browser should be added above.

# End program