        IDENTIFICATION DIVISION.
        PROGRAM-ID. captest.
        ENVIRONMENT DIVISION.
        INPUT-OUTPUT SECTION.
        FILE-CONTROL.
            SELECT DATA-FILE
                ASSIGN TO "data"
                ORGANIZATION IS LINE SEQUENTIAL
                FILE STATUS IS FS.
        DATA DIVISION.
        FILE SECTION.
        FD DATA-FILE.
        01  code-f-rec.
            05  code-lineno      pic 9(03).
            05  code-statement   pic x(20).
            05  code-p1          pic x(10).
            05  code-p2          pic x(10).
            05  code-p3          pic x(10).
        WORKING-STORAGE SECTION.
        01 SCORE PIC S9(9) USAGE BINARY VALUE 0.
        01 COMMAND_LINE_ARG PIC 9.
        01 PLAYER-ID PIC s9(9) USAGE BINARY.
        01 WIN PIC S9(9) USAGE BINARY VALUE 1.
        01 FS PIC 99.
        PROCEDURE DIVISION.
           DISPLAY 1 UPON ARGUMENT-NUMBER.
           ACCEPT COMMAND_LINE_ARG FROM ARGUMENT-VALUE.
           DISPLAY "COMMAND_LINE_ARG: " COMMAND_LINE_ARG.
           IF COMMAND_LINE_ARG < 2
              MOVE 1 TO PLAYER-ID
           ELSE
              MOVE 2 TO PLAYER-ID
           END-IF.
           DISPLAY "PLAYER-ID: " PLAYER-ID.

           DISPLAY "drone_begin".
           CALL "drone_begin".

           DISPLAY "drone_command".
           CALL "drone_command".
           CALL "lib_sleep" USING BY VALUE 5.

           DISPLAY "drone_takeoff".
           CALL "drone_takeoff".
           CALL "lib_sleep" USING BY VALUE 10.

           DISPLAY "drone_up".
           CALL "drone_up" USING BY VALUE 50.
           CALL "lib_sleep" USING BY VALUE 10.

           DISPLAY "drone_capture_image".
           CALL "drone_capture_image".

           DISPLAY "get_smile_score".
           CALL "get_smile_score" USING BY VALUE PLAYER-ID
              RETURNING SCORE.
           DISPLAY "SCORE=" SCORE.

           CALL "lib_sleep" USING BY VALUE 2.

           DISPLAY "is_winner".
           CALL "is_winner" USING BY VALUE PLAYER-ID RETURNING WIN.

           DISPLAY "WIN=" WIN.
           IF WIN = 1
               OPEN INPUT DATA-FILE
               PERFORM UNTIL 1 = 0
                   READ DATA-FILE
                       AT END
                           DISPLAY "at end"
                           EXIT PERFORM
                   END-READ
                   EVALUATE code-statement
                       WHEN "East"
                           DISPLAY "East"
                           CALL "drone_flip" USING BY VALUE 1
                           CALL "lib_sleep" USING BY VALUE 3
                       WHEN "West"
                           DISPLAY "West"
                           CALL "drone_flip" USING BY VALUE 0
                           CALL "lib_sleep" USING BY VALUE 3
                       WHEN "North"
                           DISPLAY "North"
                           CALL "drone_flip" USING BY VALUE 2
                           CALL "lib_sleep" USING BY VALUE 3
                       WHEN "South"
                           DISPLAY "South"
                           CALL "drone_flip" USING BY VALUE 3
                           CALL "lib_sleep" USING BY VALUE 3
                       WHEN OTHER
                           DISPLAY "other"
                           EXIT PERFORM
                   END-EVALUATE
               END-PERFORM
               CLOSE DATA-FILE
           END-IF

           DISPLAY "drone_land".
           CALL "drone_land".

           DISPLAY "drone_end".
           CALL "drone_end".
