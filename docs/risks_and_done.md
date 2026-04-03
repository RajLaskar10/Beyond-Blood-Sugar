# Risks & Definition of Done

## Risks & Mitigation

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Combined dataset has silent harmonization errors | Medium | High | Phase 1 verification catches this before any modeling. Rebuild in Phase 2 if needed. |
| Random forest training is too slow on 430K rows | Medium | Medium | Use `ranger` (not `randomForest`). If still slow, subsample training data (stratified 50%) for tuning, use full data for final model. |
| Class imbalance inflates performance metrics | High | High | Apply imbalance handling ONLY to training sets. Evaluate on original-distribution test sets. Report both balanced and raw accuracy. |
| Feature importance not comparable between LR and RF | High | Medium | Use `vip` with `method = "permute"` for both model types. Do not compare raw Gini importance to LR coefficients. |
| Subgroup analysis has small cell sizes | Medium | Medium | Check group sizes before fitting subgroup models. Minimum threshold: ~500 diabetic cases per subgroup. Report limitations for small groups. |
| Income tier encoding differs between 2014 and 2022 | High | High | `_INCOMG` (2014) vs `_INCOMG1` (2022) needs explicit recoding during harmonization. |
| `_SEX` column exists in 2022 but not in 2014 | Medium | Low | Confirm during data audit. If absent from 2014, drop from combined analysis or document absence. |
| Team bottleneck: modeling blocked on data prep | Medium | High | Gaurav prototypes the modeling pipeline using only the 2014 dataset while Raj handles harmonization. Namya works on EDA in parallel. |
| Scope creep: adding more models or analyses late | Medium | Medium | Scope is locked to LR + RF on 3 datasets, 4 subgroup dimensions, 3 research questions. Any additions require all 3 members to agree and must not jeopardize the April 16 deadline. |

## Definition of Done

### A phase is done when:

1. All code for that phase is merged to `main` via reviewed PRs.
2. All output files (data, figures, tables, models) are saved to the correct directories.
3. The corresponding GitHub Issues are closed and moved to **Done** on the board.
4. At least one other team member has verified the outputs make sense (e.g., row counts are correct, plots are readable, metrics are plausible).

### The project is done when:

1. All 33 issues are closed.
2. The final report knits to PDF without errors.
3. The presentation is rehearsed and timed.
4. The repo README accurately describes how to reproduce the full pipeline.
