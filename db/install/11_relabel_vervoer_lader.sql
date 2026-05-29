-- =============================================================================
-- 11_relabel_vervoer_lader.sql
--   Relabel Vervoer (4 -> 2: LOG, WERF) and Lader (4 -> 3: KOOIAAP, KRAAN, LOSMID)
--   Maps existing scaff_material_request rows BEFORE the FK lookups change.
-- =============================================================================
set define off

prompt === Insert NEW reference codes (idempotent) ===
merge into scaff_ref_vervoer t
using (
  select 'LOG'  as code, 'Door Logistiek'          as label_nl, 'By Logistics'        as label_en, 10 as sort_seq from dual union all
  select 'WERF',         'Door werf / aanvrager',                'By site / requester',                  20 from dual
) s on (t.code = s.code)
when not matched then insert (code, label_nl, label_en, sort_seq) values (s.code, s.label_nl, s.label_en, s.sort_seq)
when matched then update set t.label_nl = s.label_nl, t.label_en = s.label_en, t.sort_seq = s.sort_seq;

merge into scaff_ref_lader t
using (
  select 'KOOIAAP' as code, 'Kooiaap'              as label_nl, 'Cherry picker'        as label_en, 10 as sort_seq from dual union all
  select 'KRAAN',            'Kraan',                            'Crane',                            20 from dual union all
  select 'LOSMID',           'Losmiddelen aanwezig',             'Loaders on site',                  30 from dual
) s on (t.code = s.code)
when not matched then insert (code, label_nl, label_en, sort_seq) values (s.code, s.label_nl, s.label_en, s.sort_seq)
when matched then update set t.label_nl = s.label_nl, t.label_en = s.label_en, t.sort_seq = s.sort_seq;

prompt === Re-map existing material requests to new codes ===
update scaff_material_request
   set vervoer_code = case vervoer_code
                        when 'EIGEN'  then 'WERF'
                        when 'AFHAAL' then 'WERF'
                        when 'VRACHT' then 'LOG'
                        when 'EXTERN' then 'LOG'
                        else vervoer_code
                      end
 where vervoer_code in ('EIGEN','AFHAAL','VRACHT','EXTERN');

update scaff_material_request
   set lader_code = case lader_code
                      when 'HEFTRUCK' then 'KOOIAAP'
                      when 'HAND'     then 'LOSMID'
                      when 'GEEN'     then 'LOSMID'
                      else lader_code
                    end
 where lader_code in ('HEFTRUCK','HAND','GEEN');

prompt === Drop obsolete reference codes ===
delete from scaff_ref_vervoer where code in ('EIGEN','AFHAAL','VRACHT','EXTERN');
delete from scaff_ref_lader   where code in ('HEFTRUCK','HAND','GEEN');

commit;

prompt === Counts ===
select 'SCAFF_REF_VERVOER' as tbl, count(*) cnt from scaff_ref_vervoer
union all select 'SCAFF_REF_LADER', count(*) from scaff_ref_lader;

exit
