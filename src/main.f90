program ygpong
    ! modules
    use :: M_ncurses
    use :: IOHandle
    use :: Types
    use :: Menu
    use :: Game

    ! variables
    implicit none
    logical :: run = .true.
    integer :: input
    integer :: gameState = GameState_Menu
    integer :: rc

    call IOHandle_Init

    do while (run)
        input = getch()

        ! handle input
        select case (input)
            case (ichar('q', 2))
                run = .false.
            case default
                select case (gameState)
                    case (GameState_Menu)
                        if (Menu_HandleInput(input)) then
                            gameState = GameState_InGame
                            call Game_Init
                            select case (menu_cursorPos)
                                case (MENU_CURSOR_1PLAYER)
                                    game_players = 1
                                case (MENU_CURSOR_2PLAYERS)
                                    game_players = 2
                            end select
                        end if
                    case (GameState_InGame)
                        call Game_Update(input)
                end select
        end select

        ! handle rendering
        select case (gameState)
            case (GameState_Menu)
                call Menu_Render
            case (GameState_InGame)
                call Game_Render
        end select

        ! 30fps
        rc = napms(33)
    end do
    
    call IOHandle_Quit
end program ygpong