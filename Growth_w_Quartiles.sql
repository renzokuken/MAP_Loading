USE Sandbox
GO

/*FallScores table matches Fall scores to the student's grade*/
SELECT
FAR.PKstudent
,Grade
,FAR.School_ID
,FAR.SchoolName
,MeasurementScale
,CASE
      WHEN FAR.MeasurementScale = 'Mathematics' THEN 725
      WHEN FAR.MeasurementScale = 'Reading' THEN 753
      WHEN FAR.MeasurementScale = 'Language Usage' THEN 692
      WHEN FAR.MeasurementScale = 'General Science' THEN 814
      WHEN FAR.MeasurementScale = 'Concepts and Processes' THEN 807
      ELSE 0
END AS Subtest_ID
,TestType
,TestName
,TestRITScore AS Fall_Score
,TestPercentile
,CASE
      WHEN TestPercentile >= 75 THEN 4
      WHEN TestPercentile < 75 AND TestPercentile >= 50 THEN 3
      WHEN TestPercentile < 50 AND TestPercentile >= 25 THEN 2
      ELSE 1
END AS Quartile
INTO #tt_FallScores
FROM Assessment_Results_QA FAR
JOIN Student_by_School_QA FSBS
ON FAR.PKstudent = FSBS.PKstudent
AND FAR.School_ID = FSBS.School_ID
WHERE GrowthMeasureYN = 1

/*Select Block is for QAPurposes*/
--SELECT * FROM #tt_FallScores
--DROP TABLE #tt_FallScores

/*SpringScores table matches Spring scores to the student's grade*/
SELECT
SAR.PKstudent
,Grade
,SAR.School_ID
,SAR.SchoolName
,MeasurementScale
,CASE
      WHEN SAR.MeasurementScale = 'Mathematics' THEN 725
      WHEN SAR.MeasurementScale = 'Reading' THEN 753
      WHEN SAR.MeasurementScale = 'Language Usage' THEN 692
      WHEN SAR.MeasurementScale = 'General Science' THEN 814
      WHEN SAR.MeasurementScale = 'Concepts and Processes' THEN 807
      ELSE 0
END AS Subtest_ID
,TestType
,TestName
,TestRITScore AS Spring_Score
,TestPercentile
,CASE
      WHEN TestPercentile >= 75 THEN 4
      WHEN TestPercentile < 75 AND TestPercentile >= 50 THEN 3
      WHEN TestPercentile < 50 AND TestPercentile >= 25 THEN 2
      ELSE 1
END AS Quartile
INTO #tt_SpringScores
FROM Assessment_Results_QA_Spring SAR
LEFT JOIN Student_by_School_QA_Spring SSBS
ON SAR.PKstudent = SSBS.PKstudent
AND SAR.School_ID = SSBS.School_ID
WHERE GrowthMeasureYN = 1

/*Select Block is for QAPurposes*/
--SELECT * FROM #tt_SpringScores
--DROP TABLE #tt_SpringScores


/*MAPGrowth table pulls in the relevant growth goals, and converts Grade for matching*/
SELECT
Subtest_ID
,CASE
      WHEN Grade = 0 THEN 13
      ELSE Grade
END AS Grade
,RIT
,Growth_Goal
INTO #tt_MAPGrowth
FROM RIT_Growth
WHERE Norm_Year = 2011
AND Start_Season = 'Fall'
AND End_Season = 'Spring'
AND Subtest_ID IN (692, 725, 753, 807, 814)

/*Select Block is for QAPurposes*/
--SELECT * FROM #tt_MAPGrowth
--DROP TABLE #tt_MAPGrowth

/*JoinedScores table calculates joins Fall to Spring, calculates growth value, and pulls in growth goals*/
SELECT
TFS.PKstudent
,TFS.School_ID
,TFS.SchoolName
,TFS.Grade
,TFS.Subtest_ID
,TFS.MeasurementScale
,TFS.TestType
,TFS.TestName
,Fall_Score
,Spring_Score
,CAST(Spring_Score - Fall_Score AS Float) AS Growth_Value
,Growth_Goal
,TFS.Quartile AS Fall_Quartile
,TSS.Quartile AS Spring_Quartile
INTO #tt_JoinedScores
FROM #tt_FallScores TFS
LEFT JOIN #tt_SpringScores TSS
ON TFS.PKStudent = TSS.PKStudent
AND TFS.Grade = TSS.Grade
AND TFS.TestName = TSS.TestName
JOIN #tt_MAPGrowth MAP
ON TFS.Fall_Score = MAP.RIT
AND TFS.Grade = MAP.Grade
AND TFS.Subtest_ID = MAP.Subtest_ID
ORDER BY School_ID, Grade, Subtest_ID, PKstudent

/*Select Block is for QAPurposes*/
--SELECT * FROM #tt_JoinedScores
--DROP TABLE #tt_FallScores
--DROP TABLE #tt_SpringScores
--DROP TABLE #tt_MAPGrowth
--DROP TABLE #tt_JoinedScores



/*Final table aggregates the scores by school, grade, and subject*/
SELECT
JS.School_ID
,JS.SchoolName
,JS.Grade
,JS.Subtest_ID
,JS.MeasurementScale
,COUNT(PKstudent) AS N_Tested
,ROUND(AVG(JS.Fall_Score), 1) AS Avg_Fall_Score
,CAST(ROUND(SUM(CASE
      WHEN Fall_Quartile = 1 THEN 1
      ELSE 0
      END)*100 / (COUNT(PKstudent)+0.0) , 0) AS INT) AS Fall_Q1
,CAST(ROUND(SUM(CASE
      WHEN Fall_Quartile = 2 THEN 1
      ELSE 0
      END)*100 / (COUNT(PKstudent)+0.0) , 0) AS INT) AS Fall_Q2
,CAST(ROUND(SUM(CASE
      WHEN Fall_Quartile = 3 THEN 1
      ELSE 0
      END)*100 / (COUNT(PKstudent)+0.0) , 0) AS INT) AS Fall_Q3
,CAST(ROUND(SUM(CASE
      WHEN Fall_Quartile = 4 THEN 1
      ELSE 0
      END)*100 / (COUNT(PKstudent)+0.0) , 0) AS INT) AS Fall_Q4
,ROUND(AVG(JS.Spring_Score), 1) AS Avg_Spring_Score
,CAST(ROUND(SUM(CASE
      WHEN Spring_Quartile = 1 THEN 1
      ELSE 0
      END)*100 / (COUNT(PKstudent)+0.0) , 0) AS INT) AS Spring_Q1
,CAST(ROUND(SUM(CASE
      WHEN Spring_Quartile = 2 THEN 1
      ELSE 0
      END)*100 / (COUNT(PKstudent)+0.0) , 0) AS INT) AS Spring_Q2
,CAST(ROUND(SUM(CASE
      WHEN Spring_Quartile = 3 THEN 1
      ELSE 0
      END)*100 / (COUNT(PKstudent)+0.0) , 0) AS INT) AS Spring_Q3
,CAST(ROUND(SUM(CASE
      WHEN Spring_Quartile = 4 THEN 1
      ELSE 0
      END)*100 / (COUNT(PKstudent)+0.0) , 0) AS INT) AS Spring_Q4
,ROUND(AVG(JS.Growth_Value), 1) AS Average_Growth
,SUM(CASE
      WHEN JS.Growth_Value >= JS.Growth_Goal THEN 1
      ELSE 0
      END) AS Num_Met_Growth_Target
,CAST(ROUND(SUM(CASE 
      WHEN JS.Growth_Value >= JS.Growth_Goal THEN 1
      ELSE 0
      END)*100 / (COUNT(JS.Growth_Value)+0.0),0) AS INT) AS Percent_Met_Growth_Target
INTO #tt_Grade_Aggregates
FROM #tt_JoinedScores JS
WHERE JS.Growth_Value IS NOT NULL

GROUP BY
JS.School_ID
,JS.SchoolName
,JS.Grade
,JS.Subtest_ID
,JS.MeasurementScale

/******Join Fall Enrollment***************/

SELECT
 A.School_ID
,S.Display_Name
,A.Grade
,A.Subtest_ID
,A.MeasurementScale
,S.Total_Students AS Fall_Enrollment
,A.N_Tested
,A.Avg_Fall_Score
,A.Fall_Q1
,A.Fall_Q2
,A.Fall_Q3
,A.Fall_Q4
,A.Avg_Spring_Score
,A.Spring_Q1
,A.Spring_Q2
,A.Spring_Q3
,A.Spring_Q4
,A.Average_Growth
,A.Percent_Met_Growth_Target
FROM #tt_Grade_Aggregates A
RIGHT JOIN Enrollment_Lookup_Fall_2013 S
ON A.School_ID = S.School_ID
AND A.Grade = S.Grade
WHERE A.School_ID IS NOT NULL

ORDER BY
SchoolName
,Grade
,MeasurementScale

DROP TABLE #tt_FallScores
DROP TABLE #tt_SpringScores
DROP TABLE #tt_MAPGrowth
DROP TABLE #tt_JoinedScores
DROP TABLE #tt_Grade_Aggregates
