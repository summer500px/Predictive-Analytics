WITH p_base AS
  (SELECT photo_id, user_id, date
   FROM quest_events
   WHERE quest_id IN (89,91,97,103,109)),

     f AS
  (SELECT photo_id, status, reviewed_at
   FROM prime_licensing
   WHERE status NOT IN (0,1,8,10)),

     b AS
  ( SELECT f.photo_id,
           p_base.user_id,
           p_base.date, (CASE WHEN f.status = 2 OR (p_base.date < f.reviewed_at AND f.status <> 9) THEN 'submitted' 
                         WHEN f.status = 9 THEN 'presubmitted' 
                         WHEN f.status IN (3,6) AND p_base.date >= f.reviewed_at THEN 'prime' 
                         WHEN f.status IN (5,7) AND p_base.date >= f.reviewed_at THEN 'core' 
                         WHEN f.status = 4 AND p_base.date >= f.reviewed_at THEN 'pending' 
                         ELSE 'submitted' END) AS marketplace_status
   FROM p_base
   INNER JOIN f ON p_base.photo_id = f.photo_id), 

     d AS
  (SELECT b.photo_id,
          b.user_id,
          highest_rating AS pulse,
          b.marketplace_status,
          camera,
          category,
          (CASE 
           WHEN b.date >= editors_choice THEN 'yes' 
           ELSE 'no' END) AS editors_choice
   FROM b
   INNER JOIN photos ON b.photo_id = photos.id
   WHERE photos.active_status = 'active'
     AND nsfw = 'no'
     AND privacy <> 'private'),

     m AS
  (SELECT user_id,
          count(DISTINCT CASE WHEN status IN (3,6) THEN photo_id END) prime,
          count(DISTINCT CASE WHEN status IN (5,7) THEN photo_id END) core,
          count(DISTINCT CASE WHEN status = 8 THEN photo_id END) AS rejections,
          count(DISTINCT CASE WHEN status = 9 THEN photo_id END) AS presubmitted
   FROM prime_licensing
   WHERE (status BETWEEN 3 AND 9) AND status <> 4
   GROUP BY user_id),

     e AS
  (SELECT user_id, count(DISTINCT id) AS photograph_editors
   FROM photos
   WHERE editors_choice IS NOT NULL
   GROUP BY user_id),

     r AS
  (SELECT id
   FROM photos
   WHERE id IN (642468,
                1899558,
                5274965,
                13689167,
                37041864,
                38568598,
                41996876,
                44373650,
                49159440,
                55450630,
                55526312,
                61494663,
                68776317,
                71995589,
                72249171,
                72947133,
                74753925,
                75904561,
                77257187,
                78389767,
                78951701,
                79443705,
                84183549,
                84874165,
                86532193,
                87221523,
                91006731,
                91072335,
                92156623,
                92365775,
                92813119,
                93026771,
                93268185,
                94599617,
                95374819,
                95657905,
                96516181,
                96623875,
                97849853,
                101541795,
                101543603,
                101733279,
                101822043,
                102466525,
                102711687,
                102791581,
                103321055,
                104002091,
                104905545,
                105654127,
                105669977,
                106353149,
                106664871,
                107946029,
                110190385,
                110200045,
                110234783,
                111275847,
                111292181,
                112007217,
                112314459,
                112586093,
                113337241,
                113644917,
                113755333,
                113763639,
                114880365,
                115106269,
                115940139,
                116167703,
                116173843,
                116248829,
                117834005,
                118845049,
                119564935,
                119623755,
                119623757,
                120994463,
                121105713,
                123601313,
                123771093,
                124453347,
                124551461,
                125072911,
                125215553,
                125622961,
                126533757,
                127508211,
                127791771,
                127954307,
                128326873,
                128337071,
                128359023,
                128359723,
                128479721,
                128682055,
                128685111,
                128899631,
                129300925,
                130899963,
                131245721,
                131324387,
                131481777,
                131908305,
                132020669,
                132343581,
                133203487,
                133486235,
                133872643,
                134537207,
                135160507,
                137008593,
                137414749,
                137458057,
                137740727,
                137777895,
                137858401,
                138027617,
                138794681,
                138833247,
                138966495,
                139614627,
                139731199,
                140352031,
                140493645,
                140972281,
                141575853,
                141616887,
                141690731,
                141926223,
                142248165,
                142404935,
                142471571,
                142977175,
                143029759,
                143505865,
                143730639,
                144492347,
                144761697,
                145268441,
                145282391,
                145323253,
                145468277,
                145571843,
                145798313,
                147486737,
                147685457,
                148212187,
                148309987,
                148555703,
                148819345,
                148824459,
                148980265,
                149083663,
                149219443,
                149493363,
                149509663,
                149646981,
                150255275,
                150274273,
                150840805,
                151220351,
                151252709,
                152137895,
                152163723,
                152164839,
                152364409,
                152402311,
                152715531,
                152900341,
                152934803,
                153277117,
                153357205,
                153514611,
                153553917,
                153730387,
                153957245,
                153979933,
                154028419,
                154545293,
                154738539,
                155180537,
                155403957,
                155661123,
                155718257,
                155725113,
                155946553,
                156268363,
                156317067,
                156336153,
                156383735,
                156512761,
                156595875,
                156615679,
                156682833,
                156770137,
                156809621,
                156834917,
                156868061,
                156915657,
                157048937,
                157209299,
                157263731,
                157376875,
                157392339,
                157426747,
                157490735,
                157659629,
                157925663,
                157940871,
                157987083,
                158015907,
                158027817,
                158054345,
                158111619,
                158163409,
                158202425,
                158251235,
                158321741,
                158406837,
                158415773,
                158625741,
                158626191,
                158740617,
                158803491,
                158808449,
                158847783,
                158851051,
                158882481,
                159168669,
                159290685,
                159377049,
                159456059,
                159486841,
                159526535,
                159622783,
                159645797,
                159687793,
                159707815,
                159721679,
                159736749,
                159796933,
                159884255,
                159901267,
                159940743,
                159944395,
                159944397,
                159957569,
                159979773,
                160062459,
                160122345,
                160183693,
                160217133,
                160245827,
                160313643,
                160415297,
                160440689,
                160486657,
                160538147,
                160550863,
                160558127,
                160579359,
                160624611,
                160685823,
                160786433,
                160798317,
                160831019,
                160875549,
                160952581,
                160960451,
                160961217,
                160963091,
                160981561,
                160992861,
                160995033,
                160999827,
                161021773,
                161032631,
                161040387,
                161049111,
                161091215,
                161101013,
                161165495,
                161274067,
                161274069,
                161274073,
                161288985,
                161317513,
                161366205,
                161417045,
                161442109,
                161517079,
                161605143,
                161607313,
                161635075,
                161701039,
                161728847,
                161792227,
                161798393,
                161802547,
                161802613,
                161802617,
                161802711,
                161810983,
                161929913,
                161941917,
                161949041,
                162079677,
                162088237,
                162090055,
                162103717,
                162134853,
                162174313,
                162199953,
                162301997,
                162316853,
                162368469,
                162414305,
                162496745,
                162500977,
                162563443,
                162580075,
                162586629,
                162587025,
                162587355,
                162587439,
                162588273,
                162589173,
                162589863,
                162613537,
                162615505,
                162615507,
                162624005,
                162628383,
                162630383,
                162630389,
                162640617,
                162640619,
                162646617,
                162647019,
                162647271,
                162826423,
                162839805,
                162848133,
                162859149,
                163169713,
                163195389,
                163297347,
                163551545,
                163599431,
                163604411,
                163698673,
                163794943,
                164016519,
                164292601,
                164292777,
                164509043,
                164554401,
                164564547,
                164748245,
                164871963,
                164873725,
                164922145,
                165025925,
                165237829,
                165240441,
                165253107,
                165284857,
                165298003,
                165326497,
                165447729)),

     base AS
  (SELECT d.photo_id,
          d.pulse,
          d.editors_choice,
          d.marketplace_status,
          coalesce(photograph_editors,0) AS photograph_editors,
          coalesce(m.rejections,0) AS photograph_rejections,
          coalesce(m.prime,0) AS photograph_prime,
          coalesce(m.core,0) AS photograph_core,
          coalesce(m.presubmitted,0) AS photograph_presubmitted,
          d.category,
          (CASE 
           WHEN d.camera IS NULL THEN 'unknown' 
           WHEN cameras.camera_type = 'dslr' OR 
           (( translate(upper(d.camera),'- ([','') LIKE '%OMD%'
                AND len(d.camera) - len(translate(d.camera,'0123456789','')) = 1
                AND (translate(upper(d.camera),'- ([','') LIKE '%EM5'
                  OR translate(upper(d.camera),'- ([','') LIKE '%EM1'))

               OR ( len(translate(lower(d.camera),'abcdefghijklmnopqrstuvwxyz- ','')) = 0
                   AND translate(upper(d.camera),'- ([','') LIKE '%PENF%')

               OR ( len(d.camera) - len(translate(d.camera,'0123456789 ','')) = 1
                   AND (upper(d.camera) LIKE '%LUMIX%GH4%'
                        OR upper(d.camera) LIKE '%LUMIX%GX8%'
                        OR upper(d.camera) LIKE '%LUMIX%G7%'))

               OR (d.camera NOT LIKE '%2%'
                   AND upper(d.camera) NOT LIKE '%II%'
                   AND translate(upper(d.camera),'- ([','') NOT LIKE '%R2%'
                   AND ((upper(translate(d.camera,'- ','')) LIKE '%ALPHA7R%'
                         OR upper(translate(d.camera,' ','')) LIKE '%α7R%'
                         OR upper(translate(d.camera,' ','')) LIKE '%A7R%')
                        OR (upper(translate(d.camera,'- ','')) LIKE '%ALPHA7S%'
                            OR upper(translate(d.camera,' ','')) LIKE '%α7S%'
                            OR upper(translate(d.camera,' ','')) LIKE '%A7S%')
                        OR (upper(translate(d.camera,'- ','')) LIKE '%ALPHA99%'
                            OR upper(translate(d.camera,' ','')) LIKE '%α99%'
                            OR upper(translate(d.camera,' ','')) LIKE '%A99%')))

               OR translate(upper(d.camera),'()- ','') LIKE '%ILCE7'
               OR translate(upper(d.camera),'()- ','') LIKE '%ILCA77M2'
               OR translate(upper(d.camera),'()- ','') LIKE '%ILCE7R'
               OR translate(upper(d.camera),'()- ','') LIKE '%ILCE6000'
               OR translate(upper(d.camera),'()- ','') LIKE '%SLTA58'
               OR translate(upper(d.camera),'()- ','') LIKE '%DSCRX100M3'
               OR translate(upper(d.camera),'()- ','') LIKE '%NEX6'
               OR translate(upper(d.camera),'()- ','') LIKE '%NEX7'

               OR (translate(upper(d.camera),'()- ','') LIKE '%DF'
                     OR translate(upper(d.camera),'()- ','') LIKE 'NIKOND7200'
                     OR translate(upper(d.camera),'()- ','') LIKE 'NIKOND7100'
                     OR translate(upper(d.camera),'()- ','') LIKE 'NIKOND7000'
                     OR translate(upper(d.camera),'()- ','') LIKE 'NIKOND700'
                     OR translate(upper(d.camera),'()- ','') LIKE 'NIKOND750'

                     OR translate(upper(d.camera),'()- ','') LIKE 'NIKOND800'
                     OR translate(upper(d.camera),'()- ','') LIKE 'NIKOND80'
                     
                     OR translate(upper(d.camera),'()- ','') LIKE 'NIKOND90'

                     OR translate(upper(d.camera),'()- ','') LIKE 'NIKOND300'
                     OR translate(upper(d.camera),'()- ','') LIKE 'NIKOND3000'
                     OR translate(upper(d.camera),'()- ','') LIKE 'NIKOND3100'
                     OR translate(upper(d.camera),'()- ','') LIKE 'NIKOND3200'

                     OR translate(upper(d.camera),'()- ','') LIKE 'NIKOND500'
                     OR translate(upper(d.camera),'()- ','') LIKE 'NIKOND5100'
                     OR translate(upper(d.camera),'()- ','') LIKE 'NIKOND5200'
                     OR translate(upper(d.camera),'()- ','') LIKE 'NIKOND5300'
                     OR translate(upper(d.camera),'()- ','') LIKE 'NIKOND5500'
                     
                     OR translate(upper(d.camera),'()- ','') LIKE 'NIKOND600'
                     OR translate(upper(d.camera),'()- ','') LIKE 'NIKOND610'
                     OR upper(d.camera) LIKE 'D610'
                     )

               OR (upper(d.camera) LIKE 'CANON%T6S%'
                     OR upper(d.camera) LIKE 'CANON%T6I%'
                     OR upper(d.camera) LIKE 'CANON%T5%'
                     OR upper(d.camera) LIKE 'CANON%T5I%'
                     OR upper(d.camera) LIKE 'CANON%T3I%'
                     OR upper(d.camera) LIKE 'CANON%T2I%'
                     OR upper(d.camera) LIKE 'CANON%T1I%'
                     OR upper(d.camera) LIKE 'CANON%XSI'
                     
                     OR upper(translate(d.camera,' ','')) LIKE 'CANON%1000D'
                     OR upper(translate(d.camera,' ','')) LIKE 'CANON%1100D'
                     OR upper(translate(d.camera,' ','')) LIKE 'CANON%1200D'

                     OR upper(translate(d.camera,' ','')) LIKE 'CANON%80D'

                     OR upper(translate(d.camera,' ','')) LIKE 'CANON%7D%'
                     OR upper(translate(d.camera,' ','')) LIKE 'CANON%70D%'

                     OR upper(translate(d.camera,' ','')) LIKE 'CANON%6D%'
                     OR upper(translate(d.camera,' ','')) LIKE 'CANON%60D%'
                     OR upper(translate(d.camera,' ','')) LIKE 'CANON%600D%'

                     OR upper(translate(d.camera,' ','')) LIKE 'CANON%50D%'
                     OR upper(translate(d.camera,' ','')) LIKE 'CANON%500D%'
                     
                     OR upper(translate(d.camera,' ','')) LIKE 'CANON%40D%'
                     OR upper(translate(d.camera,' ','')) LIKE 'CANON%400D%'
                     )
                   
               OR ( upper(translate(d.camera,'- ','')) LIKE '%XPRO2%'
                   OR (upper(translate(d.camera,'- ','')) LIKE '%XT1%'
                       AND len(d.camera) -len(translate(d.camera,'1234567890',''))=1)
                   OR (upper(translate(d.camera,'- ','')) LIKE '%X100T%'
                       AND len(d.camera) -len(translate(d.camera,'1234567890',''))=3)
                   OR (upper(translate(d.camera,'- ','')) LIKE '%XT10%'
                       AND len(d.camera) -len(translate(d.camera,'1234567890',''))=2) )

               OR upper(translate(d.camera,'- ','')) LIKE '%PENTAXK5II'
               OR upper(translate(d.camera,'- ','')) LIKE '%PENTAXK52'
               OR upper(translate(d.camera,'- ','')) LIKE '%PENTAXK50')
                        THEN 'quality' 

           WHEN (cameras.camera_type <> 'smartphone' OR cameras.camera_type IS NULL) 
           AND translate(upper(d.camera),'()- ','') NOT LIKE 'FUJIFILM%'
           AND translate(upper(d.camera),'()- ','') NOT LIKE 'OLYMPUS%'
           AND translate(upper(d.camera),'()- ','') NOT LIKE 'PANASONIC%'
           AND ( ( upper(d.camera) LIKE '%CANON%'
                  AND (upper(translate(d.camera,' ','')) LIKE '%1D%'
                       OR upper(translate(d.camera,' ','')) LIKE '%5D%')
                  AND (left(translate(lower(d.camera),'abcdefghijklmnopqrstuvwxyz-() ',''),1) IN ('1',
                                                                                                  '5'))
                  AND len(d.camera) - len(translate(d.camera,'0123456789','')) <= 2 )

                OR ( d.camera NOT LIKE '%2%'
                    AND (upper(d.camera) LIKE '%II%'
                         OR translate(upper(d.camera),'- ([','') LIKE '%R2%'
                         OR translate(upper(d.camera),'- ([','') LIKE '%S2%')
                    AND ((upper(translate(d.camera,'- ','')) LIKE '%ALPHA7R%'
                          OR upper(translate(d.camera,' ','')) LIKE '%α7R%'
                          OR upper(translate(d.camera,' ','')) LIKE '%A7R%')
                         OR (upper(translate(d.camera,'- ','')) LIKE '%ALPHA7S%'
                             OR upper(translate(d.camera,' ','')) LIKE '%α7S%'
                             OR upper(translate(d.camera,' ','')) LIKE '%A7S%')) )

                OR lower(d.camera) LIKE 'ilce%7m2%' 
                OR translate(upper(d.camera),'()- ','') LIKE '%DSCRX1'
                OR translate(upper(d.camera),'()- ','') LIKE '%ILCE7RM2'
                OR translate(upper(d.camera),'()- ','') LIKE 'PENTAX645D'

                OR (translate(upper(d.camera),'()- ','') LIKE 'NIKON%D5'
                     OR translate(upper(d.camera),'()- ','') LIKE 'NIKON%D810'
                     OR translate(upper(d.camera),'()- ','') LIKE 'NIKON%D3S'
                     OR translate(upper(d.camera),'()- ','') LIKE 'NIKON%D800E%'
                     OR translate(upper(d.camera),'()- ','') LIKE 'NIKOND4S')

                OR lower(d.camera) LIKE '%leica%'

                OR translate(upper(d.camera),'()- ','') LIKE 'HERO4'
                OR translate(upper(d.camera),'()- ','') LIKE 'FC300X'
                OR translate(upper(d.camera),'()- ','') LIKE 'XENMUSEX5'
                ) THEN 'top' 
           ELSE 'else' END) AS camera_gear,
          d.camera,
          d.user_id
   FROM d
   LEFT JOIN cameras ON translate(lower(d.camera),'-. ','') = translate(lower(cameras.camera_slug),'-. ','')
   LEFT JOIN m ON d.user_id = m.user_id
   LEFT JOIN e ON d.user_id = e.user_id
   WHERE (cameras.camera_type <> 'smartphone' 
    AND upper(d.camera) NOT LIKE '%IPHONE%' 
    AND upper(d.camera) NOT LIKE '%IPAD%' 
    AND upper(d.camera) NOT LIKE '%APPLE%'
    AND upper(d.camera) NOT LIKE '%GALAXY%'
    AND upper(d.camera) NOT LIKE '%HTC%') OR cameras.camera_type IS NULL),

     filter_base AS
  (SELECT base.photo_id,
          category,
          pulse,
          photograph_editors,
          photograph_prime,
          photograph_core,
          photograph_presubmitted,
          photograph_rejections,
          (CASE 
           WHEN editors_choice = 'yes' OR marketplace_status = 'prime' THEN 'prime' 
           WHEN editors_choice = 'no' AND marketplace_status = 'submitted' THEN 'unknown' 
           ELSE marketplace_status END) AS editors_opinion,
          (CASE 
           WHEN exif_log.photo_id IS NULL THEN 'No exif' 
           ELSE json_extract_path_text(exif_log.exif, 'Exposure Program') END) AS exposure_program,
          camera_gear,
          camera,
   		  base.user_id
   FROM base
   LEFT JOIN exif_log ON base.photo_id = exif_log.photo_id),

     filter AS
  (SELECT filter_base.photo_id,
          category,
          pulse,
          photograph_editors,
          photograph_prime,
          photograph_core,
          photograph_presubmitted,
          photograph_rejections,
          editors_opinion,
          (CASE 
           WHEN exposure_program = 'Normal program' THEN 'auto' 
           WHEN exposure_program = 'Manual' THEN 'M' 
           WHEN exposure_program = '' THEN 'Removed/NA' 
           WHEN exposure_program IN ('Shutter priority','Aperture priority') THEN 'A/S' 
           WHEN exposure_program IN ('No exif','Not defined') THEN exposure_program 
           ELSE 'error/ow' END) AS exposure_program,
          camera_gear,
          camera,
   		  user_id
   FROM filter_base
WHERE exposure_program <> 'Normal program' 
   OR pulse >= 70 
   OR editors_opinion <> 'unknown'
   OR camera_gear <> 'else'
   OR (editors_opinion = 'unknown' AND 
           (photograph_editors > 0
         OR photograph_prime > 0
         OR photograph_presubmitted > 0
         OR photograph_core > 0))),

     more_exposure_p AS
(SELECT photo_id
 FROM filter
 WHERE exposure_program IN ('Removed/NA','Not defined')),

     more_exposure_m AS
(SELECT more_exposure_p.photo_id, 
 (CASE 
  WHEN json_extract_path_text(exif_log.exif, 'Exposure Mode') = '' THEN 'Removed/NA' 
  WHEN json_extract_path_text(exif_log.exif, 'Exposure Mode') ILIKE 'Auto%' THEN 'auto' 
  WHEN json_extract_path_text(exif_log.exif, 'Exposure Mode') ILIKE 'Manual%' THEN 'M' 
  ELSE 'error/ow' END) exposure_mode
 FROM more_exposure_p
 LEFT JOIN exif_log ON more_exposure_p.photo_id = exif_log.photo_id),

final as (
SELECT (CASE WHEN r.id IS NOT NULL THEN 'yes' ELSE 'no' END) shortlisted,
         filter.photo_id,
         photograph_editors,
         photograph_prime,
         photograph_core,
         photograph_presubmitted,
         photograph_rejections,
         filter.category,
         filter.pulse,
         editors_opinion,
         (CASE
            WHEN more_exposure_m.photo_id IS NULL OR more_exposure_m.exposure_mode = filter.exposure_program 
          		THEN filter.exposure_program
            WHEN filter.exposure_program = 'Not defined' AND more_exposure_m.exposure_mode = 'Removed/NA' THEN 'error/ow'
            ELSE more_exposure_m.exposure_mode END) AS exposure,
         filter.camera_gear,
         filter.camera,
  		 filter.user_id
FROM filter
LEFT JOIN more_exposure_m ON filter.photo_id = more_exposure_m.photo_id
LEFT JOIN r ON filter.photo_id = r.id)

select *
from final
where exposure in ('M','A/S')
   OR pulse >= 70 
   OR editors_opinion <> 'unknown'
   OR camera_gear = 'top'
   OR (editors_opinion = 'unknown' AND 
           (photograph_editors > 0
         OR photograph_prime > 0
         OR photograph_presubmitted > 0
         OR photograph_core > 0))
   /*OR ((camera_gear = 'quality' OR (camera_gear = 'unknown' AND exposure = 'Removed/NA')) AND
      photograph_rejections <=2)*/