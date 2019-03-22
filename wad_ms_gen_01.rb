# https://www.primarysite-kidszone.co.uk/kidszone/resources/connect4.htm
# Ruby code file - All your code should be located between the comments provided.

# Add any additional gems and global variables here
# require 'sinatra'		# remove '#' character to run sinatra wen server

# Main class module
module MS_Game
	# Input and output constants processed by subprocesses. MUST NOT change.
	TOKEN1 = "O" # mine found
	TOKEN2 = "X" # mine not found

	class Game
		attr_reader :matrix, :player1, :player2, :hotspots, :input, :output, :turn, :turnsleft, :winner, :played, :score, :resulta, :resultb, :guess
		attr_writer :matrix, :player1, :player2, :hotspots, :input, :output, :turn, :turnsleft, :winner, :played, :score, :resulta, :resultb, :guess
		
		def initialize(input, output)
			@input = input
			@output = output
		end
		
		def getinput
			txt = @input.gets.chomp
			return txt
		end
		
		# Any code/methods aimed at passing the RSpect tests should be added below.
		def start
		# Clear the screen
			system "cls"
		# Out put messsages for the players
			@output.puts getbegingame
		end
		
		def startgame
			# Display playfield
			# displayemptyframe			
			@checkedfields = []
			@totalminesremaining = @maxtotalmines

			#start processing truns
			while @totalminesremaining > 0 do
				processuserturn(@player1)
				processuserturn(@player2)
			end		

			# Get and display the winner
			winner = checkwinner
			system "cls"
			@output.puts "The winner is: #{winner}"
			getinput
		end

		def processuserturn(player)
			begin
				invalidcoordinates = true

				while invalidcoordinates do
					system "cls"
					# Display game header
					@output.puts "Scores: "
					displayplayerscores
					displaygameboard
					@output.puts "Total mines remaining: #{@totalminesremaining}"

					# Display who's turn
					@output.puts "#{player}'s turn"
					@output.puts "Enter a coordinate to uncover if mine found."

					# Ask for coordinates of field
					@output.puts "Enter row number (0-5)"
					xcoordinate = getinput.to_i
					@output.puts "Enter column number (0-6)"
					ycoordinate = getinput.to_i
					
					# Validate coordinate input
					if (xcoordinate < 0 || xcoordinate > 5)
						@output.puts "This is an invalid selection"
						getinput
						next
					end

					if (ycoordinate < 0 || ycoordinate > 6)
						@output.puts "This is an invalid selection"
						getinput
						next
					end

					if @checkedfields.include?(xcoordinate.to_s + ycoordinate.to_s)
						@output.puts "This field has already been checked"
						getinput
						next
					end

					invalidcoordinates = false
				end

				# Register user choice to check later if anyone has checked that filed yet
				@checkedfields.push(xcoordinate.to_s + ycoordinate.to_s)

				# Get value of that field and display for the users
				value = getcolumnvalue(xcoordinate, ycoordinate)

				# @output.puts value

				updategameboard(xcoordinate, ycoordinate)

				# User friendly message for either case of field value
				if value === "M"
					# Reduce the number of remaining mines
					@totalminesremaining = @totalminesremaining - 1

					@output.puts "You found a mine"

					# Increase the score of the appropriate player
					if player === @player1
						@resulta = @resulta + 1
					else
						@resultb = @resultb + 1
					end
				else
					@output.puts "No mine in here"
				end

				@output.puts "Press enter for next round"
				# Wait for user confirmation for next user's turn
				getinput
			rescue
				@output.puts "Incorrect coordinates please retry"
				retry
			end
		end

		def created_by
			return "Szilvia E Horvath"
		end
		
		def student_id
			return 51982068
		end

		def nogametoresumemessage
			return "There is no ongoing game to resume please set up a new one."
		end

		def initialgamemessage
			return "Welcome to Minesweeper!\n  
				Created by:#{created_by}\n
				Rules: \r\n
					#{explain_rules} 
				\r\n\r\n
					#{displaymenu}"
		end

		def setupmessage
			return "Setting up new game."
		end

		def explain_rules
			return "This game is played by two people and the player who finds the most mines wins the game."
		end
		
		def getbegingame
			return "Let the games begin"
		end
		
		def getnewgamecreated
			return "New game created."
		end
		
		def finish
			@output.puts "Game finished."
		end

		def getmessagefinish
			return "Game finished."
		end
		
		def displaymenu
			@output.puts "Menu: (1)Resume | (2)New | (9)Exit\n"
		end

		def getmenu
			return "Menu: (1)Resume | (2)New | (9)Exit\n"
		end
		
		def clearscores
			@resulta = 0
			@resultb = 0
			displayplayerscores
		end
		
		def displayplayerscores
			@output.puts "Player 1: #{resulta} and Player 2: #{resultb}"
		end

		def getplayerscores
			return "Player 1: #{resulta} and Player 2: #{resultb}"
		end
		
		def displayplayer1prompt
			@output.puts "Player 1 to enter coordinate (0 returns to menu)."
		end

		def getplayer1prompt
			return "Player 1 to enter coordinate (0 returns to menu)."
		end
		
		def displayplayer2prompt
			@output.puts "Player 2 to enter coordinate (0 returns to menu)."
		end

		def getplayer2prompt
			return "Player 2 to enter coordinate (0 returns to menu)."
		end
		
		def displayinvalidinputerror
			@output.puts "Invalid input."
		end

		def getinvalidinputerror
			return "Invalid input."
		end
		
		def displaynomoreroomerror
			@output.puts "No more room."
		end
		
		def displaywinner(p)
			@output.puts "Player #{p} wins."
		end

		def getnwinner(p)
			return "Player #{p} wins."
		end

		def initialgamesetup(player1, player2)
			# Setup players
			setplayer1(player1)
			setplayer2(player2)

			# Reset scores
			resetscores

			# Clear the game field
			clearcolumns
			cleargameboard
							
			# Set and place mines on game board
			generateandplacemines
		end
		
		def promptforplayer1sname
			return "Please enter player 1's name: "
		end

		def promptforplayer2sname
			return "Please enter player 2's name: "
		end

		def setplayer1(player1)
			@player1 = player1
		end

		def setplayer2(player2)
			@player2 = player2
		end
		
		def getplayer1
			return @player1
		end
		
		def getplayer2
			return @player2
		end
		
		def resetscores
			@resulta = 0
			@resultb = 0
		end

		def clearcolumns
		# Create an array and set its elements to _
				@matrix = []
				@matrix[0] = ["_", "_", "_", "_", "_", "_","_"]
				@matrix[1] = ["_", "_", "_", "_", "_", "_","_"]
				@matrix[2] = ["_", "_", "_", "_", "_", "_","_"]
				@matrix[3] = ["_", "_", "_", "_", "_", "_","_"]
				@matrix[4] = ["_", "_", "_", "_", "_", "_","_"]
				@matrix[5] = ["_", "_", "_", "_", "_", "_","_"]
				@matrix[6] = ["_", "_", "_", "_", "_", "_","_"]
		end
		
		def getcolumnvalue(x,y)
		# return the value at coordinates x,y from the matrix
			return @matrix[x][y]
		end
		
		def setmatrixcolumnvalue(c,i,v)
			if @matrix[c][i] == "_"
				@matrix[c][i] = v
			end
		end
		
		def cleargameboard
			@gamematrix = []
			@gamematrix[0] = ["_", "_", "_", "_", "_", "_","_"]
			@gamematrix[1] = ["_", "_", "_", "_", "_", "_","_"]
			@gamematrix[2] = ["_", "_", "_", "_", "_", "_","_"]
			@gamematrix[3] = ["_", "_", "_", "_", "_", "_","_"]
			@gamematrix[4] = ["_", "_", "_", "_", "_", "_","_"]
			@gamematrix[5] = ["_", "_", "_", "_", "_", "_","_"]
			@gamematrix[6] = ["_", "_", "_", "_", "_", "_","_"]
		end

		def updategameboard(row, column)
			corematrixfieldvalue = getcolumnvalue(row, column)
			if corematrixfieldvalue === "M"
				@gamematrix[row][column] = "M"
			else
				@gamematrix[row][column] = "X"
			end
		end

		def displaygameboard

			# Create a basic graphical user interface for the game field
			title = "  0 1 2 3 4 5 6 "
			rowAfull = "0|#{@gamematrix[0][0]}|#{@gamematrix[0][1]}|#{@gamematrix[0][2]}|#{@gamematrix[0][3]}|#{@gamematrix[0][4]}|#{@gamematrix[0][5]}|#{@gamematrix[0][6]}|"
			rowBfull = "1|#{@gamematrix[1][0]}|#{@gamematrix[1][1]}|#{@gamematrix[1][2]}|#{@gamematrix[1][3]}|#{@gamematrix[1][4]}|#{@gamematrix[1][5]}|#{@gamematrix[1][6]}|"
			rowCfull = "2|#{@gamematrix[2][0]}|#{@gamematrix[2][1]}|#{@gamematrix[2][2]}|#{@gamematrix[2][3]}|#{@gamematrix[2][4]}|#{@gamematrix[2][5]}|#{@gamematrix[2][6]}|"
			rowDfull = "3|#{@gamematrix[3][0]}|#{@gamematrix[3][1]}|#{@gamematrix[3][2]}|#{@gamematrix[3][3]}|#{@gamematrix[3][4]}|#{@gamematrix[3][5]}|#{@gamematrix[3][6]}|"
			rowEfull = "4|#{@gamematrix[4][0]}|#{@gamematrix[4][1]}|#{@gamematrix[4][2]}|#{@gamematrix[4][3]}|#{@gamematrix[4][4]}|#{@gamematrix[4][5]}|#{@gamematrix[4][6]}|"
			rowFfull = "5|#{@gamematrix[5][0]}|#{@gamematrix[5][1]}|#{@gamematrix[5][2]}|#{@gamematrix[5][3]}|#{@gamematrix[5][4]}|#{@gamematrix[5][5]}|#{@gamematrix[5][6]}|"
			
			# Output the graphics	
			@output.puts "#{title}"

			@output.puts "#{rowAfull}"
			@output.puts "#{rowBfull}"
			@output.puts "#{rowCfull}"
			@output.puts "#{rowDfull}"
			@output.puts "#{rowEfull}"
			@output.puts "#{rowFfull}"


		end

		def displaycurrentframe
			# Create a basic graphical user interface for the game field
				title = "+  0 1 2 3 4 5 6 "
				rowAfull = "0|#{matrix[0][0]}|#{matrix[0][1]}|#{matrix[0][2]}|#{matrix[0][3]}|#{matrix[0][4]}|#{matrix[0][5]}|#{matrix[0][6]}|"
				rowBfull = "1|#{matrix[1][0]}|#{matrix[1][1]}|#{matrix[1][2]}|#{matrix[1][3]}|#{matrix[1][4]}|#{matrix[1][5]}|#{matrix[1][6]}|"
				rowCfull = "2|#{matrix[2][0]}|#{matrix[2][1]}|#{matrix[2][2]}|#{matrix[2][3]}|#{matrix[2][4]}|#{matrix[2][5]}|#{matrix[2][6]}|"
				rowDfull = "3|#{matrix[3][0]}|#{matrix[3][1]}|#{matrix[3][2]}|#{matrix[3][3]}|#{matrix[3][4]}|#{matrix[3][5]}|#{matrix[3][6]}|"
				rowEfull = "4|#{matrix[4][0]}|#{matrix[4][1]}|#{matrix[4][2]}|#{matrix[4][3]}|#{matrix[4][4]}|#{matrix[4][5]}|#{matrix[4][6]}|"
				rowFfull = "5|#{matrix[5][0]}|#{matrix[5][1]}|#{matrix[5][2]}|#{matrix[5][3]}|#{matrix[5][4]}|#{matrix[5][5]}|#{matrix[5][6]}|"
				
			# Output the graphics	
				@output.puts "#{title}"
	
				@output.puts "#{rowAfull}"
				@output.puts "#{rowBfull}"
				@output.puts "#{rowCfull}"
				@output.puts "#{rowDfull}"
				@output.puts "#{rowEfull}"
				@output.puts "#{rowFfull}"

			# Return for web based game
			return "#{title}<br/>#{rowAfull}<br/>#{rowBfull}<br/>#{rowCfull}<br/>#{rowDfull}<br/>#{rowEfull}<br/>#{rowFfull}<br/>"
			end

		def displayemptyframe
		# Create a basic graphical user interface for the game field
			title = "  0 1 2 3 4 5 6 "
			rowAempty = "0|_|_|_|_|_|_|_|"
			rowBempty = "1|_|_|_|_|_|_|_|"
			rowCempty = "2|_|_|_|_|_|_|_|"
			rowDempty = "3|_|_|_|_|_|_|_|"
			rowEempty = "4|_|_|_|_|_|_|_|"
			rowFempty = "5|_|_|_|_|_|_|_|"
			
		# Output the graphics for console game
			@output.puts "#{title}"

			@output.puts "#{rowAempty}"
			@output.puts "#{rowBempty}"
			@output.puts "#{rowCempty}"
			@output.puts "#{rowDempty}"
			@output.puts "#{rowEempty}"
			@output.puts "#{rowFempty}"

		# Return graphics for web based game
			return "#{title}\r\n#{rowAempty}\n#{rowBempty}\n#{rowCempty}\n#{rowDempty}\n#{rowEempty}\n#{rowFempty}\n"
		end
		
		def generateandplacemines
			# The gameboard will have only up to 10 mines set
				@maxtotalmines = 10
				availablecolumns = 6
				availablerows = 5
				minematrix = []
				counter = 0
				
			# generate and place the mines on the board
				while counter < @maxtotalmines do
					col = rand(0..availablecolumns)
					row = rand(0..availablerows)

					# Do not set mines to a place where one is already set
					if minematrix.include?(col.to_s + row.to_s)
						next
					end

					minematrixstring = col.to_s + row.to_s
					@output.puts minematrixstring
					minematrix.push(minematrixstring)

					setmatrixcolumnvalue(row, col, "M")
					counter = counter + 1 
				end		
				# getinput
		end
		
		def checkwinner
		# If resulta is bigger then player 1 wins
		# If resultb is bigger then player 2 wins
			if @resulta > @resultb
				return @player1
			end
			if @resultb > @resulta
				return @player2
			end
			if @resulta == @resultb
				return "This is a tie. Both of you win."
			end
		end
		
		# Any code/methods aimed at passing the RSpect tests should be added above.
	end
end
