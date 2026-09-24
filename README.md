# resources

Past CS 61A exams, solutions, and study guides, served by GitHub Pages at
<https://cs61a.org/resources/>. The CS 61A and Data C88C course websites'
Resources pages link to the files there and fetch the exam indexes from there.

## Layout

- `<semester>/<mt1|mt2|final>/` — exam and solution PDFs (or zips), e.g.
  `fa25/mt1/61a-fa25-mt1.pdf` and `fa25/mt1/61a-fa25-mt1_sol.pdf`, served at
  `https://cs61a.org/resources/fa25/mt1/61a-fa25-mt1.pdf`. Summer offerings
  with a single midterm name it `61a-<semester>-midterm.pdf`.
- `guides/` — study guides, served at `https://cs61a.org/resources/guides/`.
- `_exams/` — exam-problem indexes by topic and `exam_files.json`, the file
  manifest (see its README). `_config.yml` includes this directory in the site.
- `scripts/` — maintenance scripts (not published).

## Adding an exam

1. Add the exam and solution files as `<semester>/<kind>/61a-<semester>-<kind>.pdf`
   and `..._sol.pdf`.
2. Run `python3 scripts/generate_exam_files.py` to update `_exams/exam_files.json`.
3. Add the exam's problems to `_exams/exam_problems_<kind>.json`.
4. Commit and push to `main`; GitHub Pages republishes the site.
