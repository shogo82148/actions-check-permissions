# actions-check-permissions

A GitHub Action for checking the permissions of GITHUB_TOKEN.

```yaml
name: test
on:
  push:
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - id: check
        uses: shogo82148/actions-check-permissions@v1

      - name: the token have no permission
        if: steps.check.outputs.permission == 'none'
        run: echo 'something to do'

      - name: the token have read permission
        if: steps.check.outputs.permission == 'read'
        run: echo 'something to do'

      - name: the token have write permission
        if: steps.check.outputs.permission == 'write'
        run: echo 'something to do'
```
