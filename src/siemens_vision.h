#ifndef _SIEMENS_VISION_HEADER_
#define _SIEMENS_VISION_HEADER_

typedef unsigned int u_int ;
#define SIEMENS_HEADERSIZE 6144

struct Siemens_vision_header {
       unsigned int     SiemensStudyDateYYYY;
       unsigned int     SiemensStudyDateMM ;
       unsigned int     SiemensStudyDateDD ;
       unsigned int     AcquisitionDateYYYY ;
       unsigned int     AcquisitionDateMM ;
       unsigned int     AcquisitionDateDD ;
       unsigned int     ImageDateYYYY ;
       unsigned int     ImageDateMM ;
       unsigned int     ImageDateDD ;
       unsigned int     SiemensStudyTimeHH ;
       unsigned int     SiemensStudyTimeMM ;
       unsigned int     SiemensStudyTimeSS;
  unsigned int i1;
       unsigned int      AcquisitionTimeHH ;
       unsigned int      AcquisitionTimeMM ;
       unsigned int      AcquisitionTimeSS ;
  unsigned int i2;
       unsigned int      ImageTimeHH ;
       unsigned int      ImageTimeMM ;
       unsigned int      ImageTimeSS ;
  char d1[16];
       char    Manufacturer[7];
  char d2[2];
       char InstitutionName[25] ;
  char d3[638];
       char PatientName[27];
       char PatientID[12];
  char d5[737];
      double     SliceThickness ;
  double x1;
      double     RepetitionTime;
      double     EchoTime;
  double x2,x3;
      double     FrequencyMHz;
  char d6[167];
      char ReceivingCoil[16];     /* offset 1767 */

#if 1                             /* RWCox */
  char d7a[1081];
      unsigned int DisplayMatrixSize ;   /* offset 2864 */
  char d7b[76] ;
#else
  char d7[1161];
#endif
      char SequencePrgName[65];   /* offset 2944 */
      char SequenceWkcName[65];
      char SequenceAuthor[9];
      char SequenceType[8];
  char d4[653];
      double     FOVRow ;
      double     FOVColumn ;
  double x4;
      double     CenterPointX ;
      double     CenterPointY ;
      double     CenterPointZ ;
      double     NormalVectorX ;
      double     NormalVectorY ;
      double     NormalVectorZ ;
      double     DistanceFromIsocenter ;
  double x5;
      double     RowVectorX ;
      double     RowVectorY ;
      double     RowVectorZ ;
      double     ColumnVectorX ;
      double     ColumnVectorY ;
      double     ColumnVectorZ ;
      char OrientationSet1Top[4];
      char OrientationSet1Left[4];
      char OrientationSet1Back[4];
      char OrientationSet2Down[4];
      char OrientationSet2Right[4];
      char OrientationSet2Front[4];
      char SequenceName[32];
  char d8[1064];
      double     PixelSizeRow ;
      double     PixelSizeColumn ;
  char d9[530];
      char TextImageNumber[4];
  char d10[9];
      char TextDate[12];
      char TextTime[5];
  char d11[230];
      char   TextSlicePosition[8];

} ;
#endif
