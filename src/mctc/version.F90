! This file is part of mctc-lib.
!
! Licensed under the Apache License, Version 2.0 (the "License");
! you may not use this file except in compliance with the License.
! You may obtain a copy of the License at
!
!     http://www.apache.org/licenses/LICENSE-2.0
!
! Unless required by applicable law or agreed to in writing, software
! distributed under the License is distributed on an "AS IS" BASIS,
! WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
! See the License for the specific language governing permissions and
! limitations under the License.

#include "mctc/defs.h"

module mctc_version
   implicit none
   private

   public :: mctc_version_string, mctc_version_compact
   public :: get_mctc_version, get_mctc_feature


   !> String representation of the mctc-lib version
   character(len=*), parameter :: mctc_version_string = "0.4.1"

   !> Numeric representation of the mctc-lib version
   integer, parameter :: mctc_version_compact(3) = [0, 4, 1]


   !> With support for JSON
   logical, parameter :: mctc_with_json = 0 /= WITH_JSON


contains


!> Getter function to retrieve mctc-lib version
pure subroutine get_mctc_version(major, minor, patch, string)

   !> Major version number of the mctc-lib version
   integer, intent(out), optional :: major

   !> Minor version number of the mctc-lib version
   integer, intent(out), optional :: minor

   !> Patch version number of the mctc-lib version
   integer, intent(out), optional :: patch

   !> String representation of the mctc-lib version
   character(len=:), allocatable, intent(out), optional :: string

   if (present(major)) then
      major = mctc_version_compact(1)
   end if
   if (present(minor)) then
      minor = mctc_version_compact(2)
   end if
   if (present(patch)) then
      patch = mctc_version_compact(3)
   end if
   if (present(string)) then
      string = mctc_version_string
   end if

end subroutine get_mctc_version


pure function get_mctc_feature(feature) result(has_feature)

   !> Feature name
   character(len=*), intent(in) :: feature

   !> Whether the feature is enabled
   logical :: has_feature

   select case(feature)
   case("json")
      has_feature = mctc_with_json
   case default
      has_feature = .false.
   end select

end function get_mctc_feature


end module mctc_version
