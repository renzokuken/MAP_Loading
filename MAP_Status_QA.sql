USE Sandbox
GO

/*This table joins the assessment results to the student roster on student ID (PKstudent) and school ID*/
SELECT
 FAR.PKstudent
,Grade
,SBS.School_ID
,FAR.SchoolName
,MeasurementScale
,GrowthMeasureYN
,TestType
,TestName
,TestRITScore
INTO #tt_Grade_Join
FROM Assessment_Results_QA_Fall FAR
JOIN Student_by_School_QA_Fall SBS
ON FAR.PKstudent = SBS.PKstudent

--SELECT * FROM #tt_Grade_Join
--DROP TABLE #tt_Grade_Join


SELECT
 GJ.PKstudent
,GJ.Grade
,GJ.SchoolName
,S.Display_Name
,S.Type
,S.Grade AS School_Grade
,S.School_ID
,GJ.MeasurementScale
,GJ.GrowthMeasureYN
,GJ.TestType
,GJ.TestName
,GJ.TestRITScore
,S.Total_Students
INTO #tt_Final
FROM #tt_Grade_Join GJ
RIGHT JOIN Enrollment_Lookup_Fall_2013 S
ON GJ.School_ID = S.School_ID
AND GJ.Grade = S.Grade

/*This table rolls the number of tests taken by school, and test name, and provides counts of Primary, Valid Survey with Goals, Valid Survey, and Invalid*/
SELECT
 F.School_ID
,F.Display_Name
,F.Grade
,F.Type
,F.MeasurementScale
,F.TestName
,F.Total_Students AS Fall_Enrollment
,SUM(CASE WHEN F.GrowthMeasureYN = 1 AND F.TestType = 'Survey with Goals' AND F.TestName LIKE '%Primary%' THEN 1 ELSE 0 END) AS N_primary
,SUM(CASE WHEN F.GrowthMeasureYN = 1 AND F.TestType = 'Survey with Goals' AND F.TestName NOT LIKE '%Primary%' THEN 1 ELSE 0 END) AS N_valid_survey_with_goals
,SUM(CASE WHEN F.GrowthMeasureYN = 1 AND F.TestType = 'Survey' AND F.TestName NOT LIKE '%Primary%' THEN 1 ELSE 0 END) AS N_valid_survey
,SUM(CASE WHEN F.GrowthMeasureYN = 0 THEN 1 ELSE 0 END) AS N_invalid
,AVG(CASE WHEN F.GrowthMeasureYN = 1 THEN TestRITScore ELSE NULL END) AS Average_RIT
FROM #tt_Final F
WHERE MeasurementScale IS NOT NULL

GROUP BY 
 F.School_ID
,F.Display_Name
,F.Grade
,F.Type
,F.MeasurementScale
,F.TestName
,F.Total_Students

ORDER BY
 Display_Name
,MeasurementScale
,Grade
,TestName

DROP TABLE #tt_Grade_Join
DROP TABLE #tt_Final