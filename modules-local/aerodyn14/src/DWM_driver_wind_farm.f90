PROGRAM DWM_driver_wind_farm
   USE IFPORT
   USE DFLIB
   USE DWM_driver_wind_farm_sub
   USE read_wind_farm_parameter_data, ONLY: NumWT, DWM_exe_name
   USE IFQWIN
   USE DWM_init_data, ONLY:InputFile
   
   IMPLICIT NONE
   
   INTEGER :: simulation_index
   INTEGER :: RESULT
   REAL :: T1,T2
    
      ! pre-processing
   CALL Driver_Init
   CALL read_wind_farm_parameter
   CALL Check_DWM_parameter
   CALL write_parameter_to_file
      
      ! sort the turbines
   CALL wind_farm_geometry
   

   
      !run the DWM for the very first base turbine to generate the turbine interaction information
   simulation_index = 0
   !RESULT = system("DWM_Wind_Farm.exe "// TRIM(Int2LStr(simulation_index)) //" V80_2MW.fst")      ! 2MW NEW
   
   !general DWM FAST input
   !RESULT = system(TRIM(DWM_exe_name)//".exe "// TRIM(Int2LStr(simulation_index)) //" "//TRIM(InputFile)//".fst")
   
   ! FAST 8
   RESULT = system(TRIM(DWM_exe_name)//".exe "// TRIM(InputFile)//".fst" // " " //TRIM(Int2LStr(simulation_index)) //" "// "DWM")
   
   !result = SetExitQQ (QWin$ExitNoPersist)
   
   
   
      ! calculate the wake sector angle and the turbine interaction information
   CALL cal_wake_sector_angle
   
   
  
      ! Run the simulation for all the turbines in the wind farm
   DO simulation_index = 1,NumWT
       !RESULT = system("DWM_Wind_Farm.exe "// TRIM(Int2LStr(simulation_index)) //" V80_2MW.fst")      ! 2MW NEW
       
       !general DWM FAST input
       !RESULT = system(TRIM(DWM_exe_name)//".exe "// TRIM(Int2LStr(simulation_index)) //" "//TRIM(InputFile)//".fst")
       
       ! FAST 8
       RESULT = system(TRIM(DWM_exe_name)//".exe "// TRIM(InputFile)//".fst" // " " //TRIM(Int2LStr(simulation_index)) //" "// "DWM")
       
       result = SetExitQQ (QWIN$EXITNOPERSIST)
       CALL rename_FAST_output(simulation_index)
   END DO
   
   
   
   CALL delete_temp_files
   
   
END PROGRAM DWM_driver_wind_farm