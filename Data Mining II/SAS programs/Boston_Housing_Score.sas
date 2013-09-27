
Data score; 
Do rm = 3.5 to 9 by 0.25; 
Do NOx = 0.35 to 0.90 by 0.025;

******         LENGTHS OF NEW CHARACTER VARIABLES         ******;
LENGTH _WARN_  $    4; 

******              LABELS FOR NEW VARIABLES              ******;
LABEL _NODE_  = 'Node' ;
      _NODE_  = .;
LABEL _LEAF_  = 'Leaf' ;
      _LEAF_  = .;
LABEL P_MEDV  = 'Predicted: MEDV' ;
      P_MEDV  = 0;
LABEL _WARN_  = 'Warnings' ;



******             ASSIGN OBSERVATION TO NODE             ******;
 DROP _ARB_P_;
 DROP _ARB_PPATH_; _ARB_PPATH_ = 1;

********** LEAF     1, NODE    24 ***************;
_ARB_P_     = 0;
_ARB_PPATH_ = 1;

 DROP _BRANCH_;
_BRANCH_ = -1;
  IF  NOT MISSING(RM ) AND 
  RM  <                6.941 THEN DO;
   _BRANCH_ =    1; 
  END; 
IF _BRANCH_ LT 0 THEN DO; 
   IF MISSING( RM  ) THEN _BRANCH_ = 1;
END; 
IF _BRANCH_ GT 0 THEN DO;

  _BRANCH_ = -1;
    IF  NOT MISSING(NOX ) AND 
    NOX  <               0.6695 THEN DO;
     _BRANCH_ =    1; 
    END; 
  IF _BRANCH_ LT 0 THEN DO; 
     IF MISSING( NOX  ) THEN _BRANCH_ = 1;
  END; 
  IF _BRANCH_ GT 0 THEN DO;

    _BRANCH_ = -1;
      IF  NOT MISSING(RM ) AND 
      RM  <                6.543 THEN DO;
       _BRANCH_ =    1; 
      END; 
    IF _BRANCH_ LT 0 THEN DO; 
       IF MISSING( RM  ) THEN _BRANCH_ = 1;
    END; 
    IF _BRANCH_ GT 0 THEN DO;

      _BRANCH_ = -1;
        IF  NOT MISSING(NOX ) AND 
        NOX  <               0.5125 THEN DO;
         _BRANCH_ =    1; 
        END; 

      IF _BRANCH_ GT 0 THEN DO;

        _BRANCH_ = -1;
          IF  NOT MISSING(RM ) AND 
          RM  <               6.0525 THEN DO;
           _BRANCH_ =    1; 
          END; 

        IF _BRANCH_ GT 0 THEN DO;

          _BRANCH_ = -1;
            IF  NOT MISSING(NOX ) AND 
            NOX  <                0.462 THEN DO;
             _BRANCH_ =    1; 
            END; 
          IF _BRANCH_ LT 0 THEN DO; 
             IF MISSING( NOX  ) THEN _BRANCH_ = 1;
          END; 
          IF _BRANCH_ GT 0 THEN DO;
            _NODE_  =                   24;
            _LEAF_  =                    1;
            P_MEDV  =     19.2612903225806;
            END;
          END;
        END;
      END;
    END;
  END;

********** LEAF     2, NODE    25 ***************;
_ARB_P_     = 0;
_ARB_PPATH_ = 1;

_BRANCH_ = -1;
  IF  NOT MISSING(RM ) AND 
  RM  <                6.941 THEN DO;
   _BRANCH_ =    1; 
  END; 
IF _BRANCH_ LT 0 THEN DO; 
   IF MISSING( RM  ) THEN _BRANCH_ = 1;
END; 
IF _BRANCH_ GT 0 THEN DO;

  _BRANCH_ = -1;
    IF  NOT MISSING(NOX ) AND 
    NOX  <               0.6695 THEN DO;
     _BRANCH_ =    1; 
    END; 
  IF _BRANCH_ LT 0 THEN DO; 
     IF MISSING( NOX  ) THEN _BRANCH_ = 1;
  END; 
  IF _BRANCH_ GT 0 THEN DO;

    _BRANCH_ = -1;
      IF  NOT MISSING(RM ) AND 
      RM  <                6.543 THEN DO;
       _BRANCH_ =    1; 
      END; 
    IF _BRANCH_ LT 0 THEN DO; 
       IF MISSING( RM  ) THEN _BRANCH_ = 1;
    END; 
    IF _BRANCH_ GT 0 THEN DO;

      _BRANCH_ = -1;
        IF  NOT MISSING(NOX ) AND 
        NOX  <               0.5125 THEN DO;
         _BRANCH_ =    1; 
        END; 

      IF _BRANCH_ GT 0 THEN DO;

        _BRANCH_ = -1;
          IF  NOT MISSING(RM ) AND 
          RM  <               6.0525 THEN DO;
           _BRANCH_ =    1; 
          END; 

        IF _BRANCH_ GT 0 THEN DO;

          _BRANCH_ = -1;
            IF  NOT MISSING(NOX ) AND 
                           0.462 <= NOX  THEN DO;
             _BRANCH_ =    2; 
            END; 

          IF _BRANCH_ GT 0 THEN DO;
            _NODE_  =                   25;
            _LEAF_  =                    2;
            P_MEDV  =               21.855;
            END;
          END;
        END;
      END;
    END;
  END;

********** LEAF     3, NODE    19 ***************;
_ARB_P_     = 0;
_ARB_PPATH_ = 1;

_BRANCH_ = -1;
  IF  NOT MISSING(RM ) AND 
  RM  <                6.941 THEN DO;
   _BRANCH_ =    1; 
  END; 
IF _BRANCH_ LT 0 THEN DO; 
   IF MISSING( RM  ) THEN _BRANCH_ = 1;
END; 
IF _BRANCH_ GT 0 THEN DO;

  _BRANCH_ = -1;
    IF  NOT MISSING(NOX ) AND 
    NOX  <               0.6695 THEN DO;
     _BRANCH_ =    1; 
    END; 
  IF _BRANCH_ LT 0 THEN DO; 
     IF MISSING( NOX  ) THEN _BRANCH_ = 1;
  END; 
  IF _BRANCH_ GT 0 THEN DO;

    _BRANCH_ = -1;
      IF  NOT MISSING(RM ) AND 
      RM  <                6.543 THEN DO;
       _BRANCH_ =    1; 
      END; 
    IF _BRANCH_ LT 0 THEN DO; 
       IF MISSING( RM  ) THEN _BRANCH_ = 1;
    END; 
    IF _BRANCH_ GT 0 THEN DO;

      _BRANCH_ = -1;
        IF  NOT MISSING(NOX ) AND 
        NOX  <               0.5125 THEN DO;
         _BRANCH_ =    1; 
        END; 

      IF _BRANCH_ GT 0 THEN DO;

        _BRANCH_ = -1;
          IF  NOT MISSING(RM ) AND 
                        6.0525 <= RM  THEN DO;
           _BRANCH_ =    2; 
          END; 
        IF _BRANCH_ LT 0 THEN DO; 
           IF MISSING( RM  ) THEN _BRANCH_ = 2;
        END; 
        IF _BRANCH_ GT 0 THEN DO;
          _NODE_  =                   19;
          _LEAF_  =                    3;
          P_MEDV  =     23.5985714285714;
          END;
        END;
      END;
    END;
  END;

********** LEAF     4, NODE    26 ***************;
_ARB_P_     = 0;
_ARB_PPATH_ = 1;

_BRANCH_ = -1;
  IF  NOT MISSING(RM ) AND 
  RM  <                6.941 THEN DO;
   _BRANCH_ =    1; 
  END; 
IF _BRANCH_ LT 0 THEN DO; 
   IF MISSING( RM  ) THEN _BRANCH_ = 1;
END; 
IF _BRANCH_ GT 0 THEN DO;

  _BRANCH_ = -1;
    IF  NOT MISSING(NOX ) AND 
    NOX  <               0.6695 THEN DO;
     _BRANCH_ =    1; 
    END; 
  IF _BRANCH_ LT 0 THEN DO; 
     IF MISSING( NOX  ) THEN _BRANCH_ = 1;
  END; 
  IF _BRANCH_ GT 0 THEN DO;

    _BRANCH_ = -1;
      IF  NOT MISSING(RM ) AND 
      RM  <                6.543 THEN DO;
       _BRANCH_ =    1; 
      END; 
    IF _BRANCH_ LT 0 THEN DO; 
       IF MISSING( RM  ) THEN _BRANCH_ = 1;
    END; 
    IF _BRANCH_ GT 0 THEN DO;

      _BRANCH_ = -1;
        IF  NOT MISSING(NOX ) AND 
                      0.5125 <= NOX  THEN DO;
         _BRANCH_ =    2; 
        END; 
      IF _BRANCH_ LT 0 THEN DO; 
         IF MISSING( NOX  ) THEN _BRANCH_ = 2;
      END; 
      IF _BRANCH_ GT 0 THEN DO;

        _BRANCH_ = -1;
          IF  NOT MISSING(NOX ) AND 
          NOX  <               0.6275 THEN DO;
           _BRANCH_ =    1; 
          END; 
        IF _BRANCH_ LT 0 THEN DO; 
           IF MISSING( NOX  ) THEN _BRANCH_ = 1;
        END; 
        IF _BRANCH_ GT 0 THEN DO;

          _BRANCH_ = -1;
            IF  NOT MISSING(RM ) AND 
            RM  <               5.6425 THEN DO;
             _BRANCH_ =    1; 
            END; 

          IF _BRANCH_ GT 0 THEN DO;
            _NODE_  =                   26;
            _LEAF_  =                    4;
            P_MEDV  =     14.7947368421052;
            END;
          END;
        END;
      END;
    END;
  END;

********** LEAF     5, NODE    27 ***************;
_ARB_P_     = 0;
_ARB_PPATH_ = 1;

_BRANCH_ = -1;
  IF  NOT MISSING(RM ) AND 
  RM  <                6.941 THEN DO;
   _BRANCH_ =    1; 
  END; 
IF _BRANCH_ LT 0 THEN DO; 
   IF MISSING( RM  ) THEN _BRANCH_ = 1;
END; 
IF _BRANCH_ GT 0 THEN DO;

  _BRANCH_ = -1;
    IF  NOT MISSING(NOX ) AND 
    NOX  <               0.6695 THEN DO;
     _BRANCH_ =    1; 
    END; 
  IF _BRANCH_ LT 0 THEN DO; 
     IF MISSING( NOX  ) THEN _BRANCH_ = 1;
  END; 
  IF _BRANCH_ GT 0 THEN DO;

    _BRANCH_ = -1;
      IF  NOT MISSING(RM ) AND 
      RM  <                6.543 THEN DO;
       _BRANCH_ =    1; 
      END; 
    IF _BRANCH_ LT 0 THEN DO; 
       IF MISSING( RM  ) THEN _BRANCH_ = 1;
    END; 
    IF _BRANCH_ GT 0 THEN DO;

      _BRANCH_ = -1;
        IF  NOT MISSING(NOX ) AND 
                      0.5125 <= NOX  THEN DO;
         _BRANCH_ =    2; 
        END; 
      IF _BRANCH_ LT 0 THEN DO; 
         IF MISSING( NOX  ) THEN _BRANCH_ = 2;
      END; 
      IF _BRANCH_ GT 0 THEN DO;

        _BRANCH_ = -1;
          IF  NOT MISSING(NOX ) AND 
          NOX  <               0.6275 THEN DO;
           _BRANCH_ =    1; 
          END; 
        IF _BRANCH_ LT 0 THEN DO; 
           IF MISSING( NOX  ) THEN _BRANCH_ = 1;
        END; 
        IF _BRANCH_ GT 0 THEN DO;

          _BRANCH_ = -1;
            IF  NOT MISSING(RM ) AND 
                          5.6425 <= RM  THEN DO;
             _BRANCH_ =    2; 
            END; 
          IF _BRANCH_ LT 0 THEN DO; 
             IF MISSING( RM  ) THEN _BRANCH_ = 2;
          END; 
          IF _BRANCH_ GT 0 THEN DO;
            _NODE_  =                   27;
            _LEAF_  =                    5;
            P_MEDV  =     19.1040983606557;
            END;
          END;
        END;
      END;
    END;
  END;

********** LEAF     6, NODE    21 ***************;
_ARB_P_     = 0;
_ARB_PPATH_ = 1;

_BRANCH_ = -1;
  IF  NOT MISSING(RM ) AND 
  RM  <                6.941 THEN DO;
   _BRANCH_ =    1; 
  END; 
IF _BRANCH_ LT 0 THEN DO; 
   IF MISSING( RM  ) THEN _BRANCH_ = 1;
END; 
IF _BRANCH_ GT 0 THEN DO;

  _BRANCH_ = -1;
    IF  NOT MISSING(NOX ) AND 
    NOX  <               0.6695 THEN DO;
     _BRANCH_ =    1; 
    END; 
  IF _BRANCH_ LT 0 THEN DO; 
     IF MISSING( NOX  ) THEN _BRANCH_ = 1;
  END; 
  IF _BRANCH_ GT 0 THEN DO;

    _BRANCH_ = -1;
      IF  NOT MISSING(RM ) AND 
      RM  <                6.543 THEN DO;
       _BRANCH_ =    1; 
      END; 
    IF _BRANCH_ LT 0 THEN DO; 
       IF MISSING( RM  ) THEN _BRANCH_ = 1;
    END; 
    IF _BRANCH_ GT 0 THEN DO;

      _BRANCH_ = -1;
        IF  NOT MISSING(NOX ) AND 
                      0.5125 <= NOX  THEN DO;
         _BRANCH_ =    2; 
        END; 
      IF _BRANCH_ LT 0 THEN DO; 
         IF MISSING( NOX  ) THEN _BRANCH_ = 2;
      END; 
      IF _BRANCH_ GT 0 THEN DO;

        _BRANCH_ = -1;
          IF  NOT MISSING(NOX ) AND 
                        0.6275 <= NOX  THEN DO;
           _BRANCH_ =    2; 
          END; 

        IF _BRANCH_ GT 0 THEN DO;
          _NODE_  =                   21;
          _LEAF_  =                    6;
          P_MEDV  =     26.9666666666666;
          END;
        END;
      END;
    END;
  END;

********** LEAF     7, NODE     9 ***************;
_ARB_P_     = 0;
_ARB_PPATH_ = 1;

_BRANCH_ = -1;
  IF  NOT MISSING(RM ) AND 
  RM  <                6.941 THEN DO;
   _BRANCH_ =    1; 
  END; 
IF _BRANCH_ LT 0 THEN DO; 
   IF MISSING( RM  ) THEN _BRANCH_ = 1;
END; 
IF _BRANCH_ GT 0 THEN DO;

  _BRANCH_ = -1;
    IF  NOT MISSING(NOX ) AND 
    NOX  <               0.6695 THEN DO;
     _BRANCH_ =    1; 
    END; 
  IF _BRANCH_ LT 0 THEN DO; 
     IF MISSING( NOX  ) THEN _BRANCH_ = 1;
  END; 
  IF _BRANCH_ GT 0 THEN DO;

    _BRANCH_ = -1;
      IF  NOT MISSING(RM ) AND 
                     6.543 <= RM  THEN DO;
       _BRANCH_ =    2; 
      END; 

    IF _BRANCH_ GT 0 THEN DO;
      _NODE_  =                    9;
      _LEAF_  =                    7;
      P_MEDV  =     27.4118644067796;
      END;
    END;
  END;

********** LEAF     8, NODE    10 ***************;
_ARB_P_     = 0;
_ARB_PPATH_ = 1;

_BRANCH_ = -1;
  IF  NOT MISSING(RM ) AND 
  RM  <                6.941 THEN DO;
   _BRANCH_ =    1; 
  END; 
IF _BRANCH_ LT 0 THEN DO; 
   IF MISSING( RM  ) THEN _BRANCH_ = 1;
END; 
IF _BRANCH_ GT 0 THEN DO;

  _BRANCH_ = -1;
    IF  NOT MISSING(NOX ) AND 
                  0.6695 <= NOX  THEN DO;
     _BRANCH_ =    2; 
    END; 

  IF _BRANCH_ GT 0 THEN DO;

    _BRANCH_ = -1;
      IF  NOT MISSING(NOX ) AND 
      NOX  <               0.7065 THEN DO;
       _BRANCH_ =    1; 
      END; 

    IF _BRANCH_ GT 0 THEN DO;
      _NODE_  =                   10;
      _LEAF_  =                    8;
      P_MEDV  =     10.2052631578947;
      END;
    END;
  END;

********** LEAF     9, NODE    16 ***************;
_ARB_P_     = 0;
_ARB_PPATH_ = 1;

_BRANCH_ = -1;
  IF  NOT MISSING(RM ) AND 
  RM  <                6.941 THEN DO;
   _BRANCH_ =    1; 
  END; 
IF _BRANCH_ LT 0 THEN DO; 
   IF MISSING( RM  ) THEN _BRANCH_ = 1;
END; 
IF _BRANCH_ GT 0 THEN DO;

  _BRANCH_ = -1;
    IF  NOT MISSING(NOX ) AND 
                  0.6695 <= NOX  THEN DO;
     _BRANCH_ =    2; 
    END; 

  IF _BRANCH_ GT 0 THEN DO;

    _BRANCH_ = -1;
      IF  NOT MISSING(NOX ) AND 
                    0.7065 <= NOX  THEN DO;
       _BRANCH_ =    2; 
      END; 
    IF _BRANCH_ LT 0 THEN DO; 
       IF MISSING( NOX  ) THEN _BRANCH_ = 2;
    END; 
    IF _BRANCH_ GT 0 THEN DO;

      _BRANCH_ = -1;
        IF  NOT MISSING(NOX ) AND 
        NOX  <                0.755 THEN DO;
         _BRANCH_ =    1; 
        END; 
      IF _BRANCH_ LT 0 THEN DO; 
         IF MISSING( NOX  ) THEN _BRANCH_ = 1;
      END; 
      IF _BRANCH_ GT 0 THEN DO;
        _NODE_  =                   16;
        _LEAF_  =                    9;
        P_MEDV  =     14.7085714285714;
        END;
      END;
    END;
  END;

********** LEAF    10, NODE    22 ***************;
_ARB_P_     = 0;
_ARB_PPATH_ = 1;

_BRANCH_ = -1;
  IF  NOT MISSING(RM ) AND 
  RM  <                6.941 THEN DO;
   _BRANCH_ =    1; 
  END; 
IF _BRANCH_ LT 0 THEN DO; 
   IF MISSING( RM  ) THEN _BRANCH_ = 1;
END; 
IF _BRANCH_ GT 0 THEN DO;

  _BRANCH_ = -1;
    IF  NOT MISSING(NOX ) AND 
                  0.6695 <= NOX  THEN DO;
     _BRANCH_ =    2; 
    END; 

  IF _BRANCH_ GT 0 THEN DO;

    _BRANCH_ = -1;
      IF  NOT MISSING(NOX ) AND 
                    0.7065 <= NOX  THEN DO;
       _BRANCH_ =    2; 
      END; 
    IF _BRANCH_ LT 0 THEN DO; 
       IF MISSING( NOX  ) THEN _BRANCH_ = 2;
    END; 
    IF _BRANCH_ GT 0 THEN DO;

      _BRANCH_ = -1;
        IF  NOT MISSING(NOX ) AND 
                       0.755 <= NOX  THEN DO;
         _BRANCH_ =    2; 
        END; 

      IF _BRANCH_ GT 0 THEN DO;

        _BRANCH_ = -1;
          IF  NOT MISSING(NOX ) AND 
          NOX  <               0.8205 THEN DO;
           _BRANCH_ =    1; 
          END; 

        IF _BRANCH_ GT 0 THEN DO;
          _NODE_  =                   22;
          _LEAF_  =                   10;
          P_MEDV  =              20.9125;
          END;
        END;
      END;
    END;
  END;

********** LEAF    11, NODE    23 ***************;
_ARB_P_     = 0;
_ARB_PPATH_ = 1;

_BRANCH_ = -1;
  IF  NOT MISSING(RM ) AND 
  RM  <                6.941 THEN DO;
   _BRANCH_ =    1; 
  END; 
IF _BRANCH_ LT 0 THEN DO; 
   IF MISSING( RM  ) THEN _BRANCH_ = 1;
END; 
IF _BRANCH_ GT 0 THEN DO;

  _BRANCH_ = -1;
    IF  NOT MISSING(NOX ) AND 
                  0.6695 <= NOX  THEN DO;
     _BRANCH_ =    2; 
    END; 

  IF _BRANCH_ GT 0 THEN DO;

    _BRANCH_ = -1;
      IF  NOT MISSING(NOX ) AND 
                    0.7065 <= NOX  THEN DO;
       _BRANCH_ =    2; 
      END; 
    IF _BRANCH_ LT 0 THEN DO; 
       IF MISSING( NOX  ) THEN _BRANCH_ = 2;
    END; 
    IF _BRANCH_ GT 0 THEN DO;

      _BRANCH_ = -1;
        IF  NOT MISSING(NOX ) AND 
                       0.755 <= NOX  THEN DO;
         _BRANCH_ =    2; 
        END; 

      IF _BRANCH_ GT 0 THEN DO;

        _BRANCH_ = -1;
          IF  NOT MISSING(NOX ) AND 
                        0.8205 <= NOX  THEN DO;
           _BRANCH_ =    2; 
          END; 
        IF _BRANCH_ LT 0 THEN DO; 
           IF MISSING( NOX  ) THEN _BRANCH_ = 2;
        END; 
        IF _BRANCH_ GT 0 THEN DO;
          _NODE_  =                   23;
          _LEAF_  =                   11;
          P_MEDV  =               16.425;
          END;
        END;
      END;
    END;
  END;

********** LEAF    12, NODE    12 ***************;
_ARB_P_     = 0;
_ARB_PPATH_ = 1;

_BRANCH_ = -1;
  IF  NOT MISSING(RM ) AND 
                 6.941 <= RM  THEN DO;
   _BRANCH_ =    2; 
  END; 

IF _BRANCH_ GT 0 THEN DO;

  _BRANCH_ = -1;
    IF  NOT MISSING(RM ) AND 
    RM  <                7.437 THEN DO;
     _BRANCH_ =    1; 
    END; 
  IF _BRANCH_ LT 0 THEN DO; 
     IF MISSING( RM  ) THEN _BRANCH_ = 1;
  END; 
  IF _BRANCH_ GT 0 THEN DO;

    _BRANCH_ = -1;
      IF  NOT MISSING(NOX ) AND 
      NOX  <                0.639 THEN DO;
       _BRANCH_ =    1; 
      END; 
    IF _BRANCH_ LT 0 THEN DO; 
       IF MISSING( NOX  ) THEN _BRANCH_ = 1;
    END; 
    IF _BRANCH_ GT 0 THEN DO;
      _NODE_  =                   12;
      _LEAF_  =                   12;
      P_MEDV  =     33.3157894736842;
      END;
    END;
  END;

********** LEAF    13, NODE    13 ***************;
_ARB_P_     = 0;
_ARB_PPATH_ = 1;

_BRANCH_ = -1;
  IF  NOT MISSING(RM ) AND 
                 6.941 <= RM  THEN DO;
   _BRANCH_ =    2; 
  END; 

IF _BRANCH_ GT 0 THEN DO;

  _BRANCH_ = -1;
    IF  NOT MISSING(RM ) AND 
    RM  <                7.437 THEN DO;
     _BRANCH_ =    1; 
    END; 
  IF _BRANCH_ LT 0 THEN DO; 
     IF MISSING( RM  ) THEN _BRANCH_ = 1;
  END; 
  IF _BRANCH_ GT 0 THEN DO;

    _BRANCH_ = -1;
      IF  NOT MISSING(NOX ) AND 
                     0.639 <= NOX  THEN DO;
       _BRANCH_ =    2; 
      END; 

    IF _BRANCH_ GT 0 THEN DO;
      _NODE_  =                   13;
      _LEAF_  =                   13;
      P_MEDV  =                 26.4;
      END;
    END;
  END;

********** LEAF    14, NODE     7 ***************;
_ARB_P_     = 0;
_ARB_PPATH_ = 1;

_BRANCH_ = -1;
  IF  NOT MISSING(RM ) AND 
                 6.941 <= RM  THEN DO;
   _BRANCH_ =    2; 
  END; 

IF _BRANCH_ GT 0 THEN DO;

  _BRANCH_ = -1;
    IF  NOT MISSING(RM ) AND 
                   7.437 <= RM  THEN DO;
     _BRANCH_ =    2; 
    END; 

  IF _BRANCH_ GT 0 THEN DO;
    _NODE_  =                    7;
    _LEAF_  =                   14;
    P_MEDV  =     45.0966666666666;
    END;
  END;

****************************************************************;
******          END OF DECISION TREE SCORING CODE         ******;
****************************************************************;

output; end; end; 
proc print data=score; run; 
proc sort data=score; by _LEAF_; 
proc means data=score; 
  var P_MEDV RM NOx; 
  by _LEAF_; 
  run;
proc g3d; plot NOX*RM=P_MEDV; 
run; 
