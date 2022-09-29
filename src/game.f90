module Game
    ! modules
    use :: M_ncurses
    use :: Types
    use, intrinsic :: iso_c_binding

    ! variables
    implicit none
    integer            :: game_player1Position
    integer            :: game_player2Position
    integer, parameter :: game_paddleHeight = 4
    type(FVec2_t)      :: game_ballPosition
    type(FVec2_t)      :: game_ballSpeed
    integer            :: game_players

    ! functions
    contains
    subroutine Game_Init()
        type(Vec2_t) :: screenSize
        
        call getmaxyx(stdscr, screenSize%y, screenSize%x)
        game_ballPosition%x  = screenSize%x / 2
        game_ballPosition%y  = screenSize%y / 2
        game_ballSpeed%x     = 0.7
        game_ballSpeed%y     = 0.25
        game_player1Position = (screenSize%y / 2) - (game_paddleHeight / 2)
        game_player2Position = game_player1Position
    end subroutine Game_Init

    subroutine Game_Update(input)
        integer       :: input
        type (Vec2_t) :: screenSize
        real          :: random

        call getmaxyx(stdscr, screenSize%y, screenSize%x)

        select case (input)
            case (KEY_UP)
                if (game_player1Position /= 0) then
                    game_player1Position = int(game_player1Position - 3)
                end if
            case (KEY_DOWN)
                if (game_player1Position /= screenSize%y - game_paddleHeight) then
                    game_player1Position = int(game_player1Position + 3)
                end if
        end select

        if (game_players > 1) then
            select case (input)
                case (ichar('w', 2))
                    if (game_player2Position /= 0) then
                        game_player2Position = game_player2Position - 3
                    end if
                case (ichar('s', 2))
                    if (game_player2Position /= screenSize%y - game_paddleHeight) then
                        game_player2Position = game_player2Position + 3
                    end if
            end select
        end if

        game_ballPosition%x = game_ballPosition%x + game_ballSpeed%x
        game_ballPosition%y = game_ballPosition%y + game_ballSpeed%y

        if (int(game_ballPosition%x) <= 0) then
            call random_number(random)
            game_ballSpeed%x = 1.0
            game_ballSpeed%y = 1 - (random * 2)
            
            game_ballPosition%x  = screenSize%x / 2
            game_ballPosition%y  = screenSize%y / 2
        else if (int(game_ballPosition%x) >= screenSize%x - 1) then
            call random_number(random)
            game_ballSpeed%x = -1.0
            game_ballSpeed%y = 1 - (random * 2)
            
            game_ballPosition%x  = screenSize%x / 2
            game_ballPosition%y  = screenSize%y / 2
        else if (int(game_ballPosition%y) <= 0) then
            game_ballSpeed%y = game_ballSpeed%y * (-1)
        else if (int(game_ballPosition%y) >= screenSize%y - 1) then
            game_ballSpeed%y = game_ballSpeed%y * (-1)
        end if

        if ( &
            ( &
                (game_ballPosition%x <= 1) .and. &
                (game_ballPosition%y >= int(game_player1Position)) .and. &
                (game_ballPosition%y <= int(game_player1Position) + game_paddleHeight) &
            ) .or. &
            ( &
                (game_ballPosition%x >= screenSize%x - 2) .and. &
                (game_ballPosition%y >= int(game_player2Position)) .and. &
                (game_ballPosition%y <= int(game_player2Position) + game_paddleHeight) &
            ) &
        ) then
            game_ballSpeed%x = game_ballSpeed%x * (-1)
        end if
    end subroutine Game_Update

    subroutine Game_Render()
        integer       :: rc
        type (Vec2_t) :: screenSize

        call getmaxyx(stdscr, screenSize%y, screenSize%x)

        rc = erase()

        ! draw middle
        rc = mvvline(0, int(screenSize%x / 2), ACS_CKBOARD, screenSize%y)

        ! draw paddles
        rc = attron(A_REVERSE)
        rc = mvvline(game_player1Position, 1, ichar(' ', 8), game_paddleHeight)
        rc = mvvline( &
            game_player2Position, screenSize%x - 2, ichar(' ', 8), game_paddleHeight &
        )
        rc = attroff(A_REVERSE)

        ! draw ball
        rc = mvaddch(nint(game_ballPosition%y), nint(game_ballPosition%x), ichar('O', 8))

        rc = refresh()
    end subroutine Game_Render
end module Game