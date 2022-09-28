module Menu
    ! variables
    implicit none
    integer :: menu_cursorPos = 1
    integer, parameter :: MENU_CURSOR_1PLAYER = 1
    integer, parameter :: MENU_CURSOR_2PLAYERS = 2

    ! functions
    contains
    function Menu_HandleInput(input)
        use :: M_ncurses
    
        integer :: input
        logical :: Menu_HandleInput
        Menu_HandleInput = .false.

        select case (input)
            case (KEY_UP)
                if (menu_cursorPos /= 1) then
                    menu_cursorPos = menu_cursorPos - 1
                end if
            case (KEY_DOWN)
                if (menu_cursorPos /= 2) then
                    menu_cursorPos = menu_cursorPos + 1
                end if
            case (ichar(' ', 2))
                Menu_HandleInput = .true.
        end select
    end function Menu_HandleInput

    subroutine Menu_Render()
        use            :: M_ncurses
        use            :: Constants
        use, intrinsic :: iso_c_binding
    
        integer :: rc

        rc = erase()

        ! title
        rc = move(1, 1)
        rc = attron(A_BOLD)
        rc = addstr(APP_NAME // c_null_char)
        rc = attroff(A_BOLD)

        ! buttons
        rc = move(3, 3)
        rc = addstr("1 player" // c_null_char)
        rc = move(4, 3)
        rc = addstr("2 players" // c_null_char)

        ! cursor
        rc = move(2 + menu_cursorPos, 1)
        rc = attron(A_BOLD)
        rc = addstr(">" // c_null_char)
        rc = attroff(A_BOLD)
    end subroutine Menu_Render
end module Menu