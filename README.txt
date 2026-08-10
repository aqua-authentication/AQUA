A QUALITY MODEL FOR AUTHENTICATION SOLUTIONS — QUICK GUIDE

1. Edit the written content
- Authentication solution: auth-sol-table.qmd
- Authenticator employment: auth-employ-table.qmd
- Authenticator: authenticator-table.qmd
- Main page text and section order: index.qmd

Example:
Change the text inside a subfactor card in auth-sol-table.qmd, then save the file.

2. Edit the tree diagrams
- Authentication solution: trees/solution-tree.dot
- Authenticator employment: trees/employment-tree.dot
- Authenticator: trees/authenticator-tree.dot

Example:
Change:
label="Ease of use"
to:
label="Simple use"

Then run render-trees.cmd.

3. Create the final HTML
Run render-html.cmd.

The finished file is created at:
_output/a-quality-model-for-authentication-solutions.html