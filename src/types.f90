module Types
    enum, bind(c)
        enumerator :: GameState_Menu = 1
        enumerator :: GameState_InGame
    end enum

    type :: Vec2_t
        integer :: x, y
    end type

    type :: FVec2_t
        real :: x, y
    end type
end module Types