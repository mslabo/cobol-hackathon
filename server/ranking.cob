        IDENTIFICATION DIVISION.
        PROGRAM-ID. ranking.

        ENVIRONMENT DIVISION.
        INPUT-OUTPUT SECTION.
        FILE-CONTROL.

        SELECT RESULT ASSIGN TO '/home/ec2-user/result.txt'
            ORGANIZATION IS LINE SEQUENTIAL
            FILE STATUS IS RESULT-STATUS.
        SELECT RANKING ASSIGN TO '/home/ec2-user/ranking.txt'
            ORGANIZATION IS LINE SEQUENTIAL
            FILE STATUS IS RANKING-STATUS.
        SELECT SORT-FILE ASSIGN TO '/home/ec2-user/sort.wrk'.

        DATA DIVISION.
        FILE SECTION.
        FD RESULT.
        01 FILE-RECORD.
           05 Y PIC 9(4).
           05 M PIC 9(2).
           05 D PIC 9(2).
           05 ho PIC 9(2).
           05 mi PIC 9(2).
           05 se PIC 9(2).
           05 NAME PIC X(20).
           05 SCORE PIC 9(5).
        FD RANKING.
        01 FILE-RECORD2 PIC X(39).
        SD SORT-FILE.
        01 SORT-RECORD PIC X(39).

        WORKING-STORAGE SECTION.
        01 RESULT-STATUS PIC XX.
        01 RANKING-STATUS PIC XX.

        PROCEDURE DIVISION.
        MAIN SECTION.

        SORT SORT-FILE
          DESCENDING SCORE
          USING RESULT
          GIVING RANKING.
