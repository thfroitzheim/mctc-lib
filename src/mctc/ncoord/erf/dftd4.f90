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

!> @file mctc/ncoord/erf_en.f90
!> Provides an implementation for the CN as used dftd4

!> Coordination number implementation with single error function and EN-weighting for dftd4
module mctc_ncoord_erf_dftd4
   use mctc_env, only : wp
   use mctc_io, only : structure_type
   use mctc_data_covrad, only : get_covalent_rad
   use mctc_data_paulingen, only : get_pauling_en
   use mctc_ncoord_erf, only : erf_ncoord_type
   implicit none
   private

   public :: new_erf_dftd4_ncoord

   !> Coordination number evaluator
   type, public, extends(erf_ncoord_type) :: erf_dftd4_ncoord_type
      real(wp), allocatable :: en(:)
   contains
      !> Evaluates pairwise electronegativity factor
      procedure :: get_en_factor
   end type erf_dftd4_ncoord_type

   !> Steepness of counting function
   real(wp), parameter :: default_kcn = 7.5_wp

   real(wp), parameter :: default_cutoff = 25.0_wp

   !> Parameter for electronegativity scaling
   real(wp), parameter :: k4 = 4.10451_wp

   !> Parameter for electronegativity scaling
   real(wp), parameter :: k5 = 19.08857_wp

   !> Parameter for electronegativity scaling
   real(wp), parameter :: k6 = 2*11.28174_wp**2

contains


   subroutine new_erf_dftd4_ncoord(self, mol, kcn, cutoff, rcov, en)
      !> Coordination number container
      type(erf_dftd4_ncoord_type), intent(out) :: self
      !> Molecular structure data
      type(structure_type), intent(in) :: mol
      !> Steepness of counting function
      real(wp), optional :: kcn
      !> Real space cutoff
      real(wp), intent(in), optional :: cutoff
      !> Covalent radii
      real(wp), intent(in), optional :: rcov(:)
      !> Electronegativity
      real(wp), intent(in), optional :: en(:)
      
      if(present(kcn)) then
         self%kcn = kcn
      else
         self%kcn = default_kcn
      end if

      if (present(cutoff)) then
         self%cutoff = cutoff
      else
         self%cutoff = default_cutoff
      end if

      allocate(self%rcov(mol%nid))
      if (present(rcov)) then
         self%rcov(:) = rcov
      else   
         self%rcov(:) = get_covalent_rad(mol%num)
      end if

      allocate(self%en(mol%nid))
      if (present(en)) then
         self%en(:) = en
      else
         self%en(:) = get_pauling_en(mol%num)
      end if

      self%directed_factor = 1.0_wp

   end subroutine new_erf_dftd4_ncoord


   !> Evaluates pairwise electronegativity factor if non applies
   elemental function get_en_factor(self, izp, jzp) result(en_factor)
      !> Coordination number container
      class(erf_dftd4_ncoord_type), intent(in) :: self
      !> Atom i index
      integer, intent(in)  :: izp
      !> Atom j index
      integer, intent(in)  :: jzp

      real(wp) :: en_factor

      en_factor = k4*exp(-(abs(self%en(izp)-self%en(jzp)) + k5)**2/k6)
      
   end function get_en_factor

end module mctc_ncoord_erf_dftd4