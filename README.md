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

## Limitations

The action only checks whether the `GITHUB_TOKEN` has the contents scope permission.
You can't get any information about other scopes.
See [Permissions for the `GITHUB_TOKEN`](https://docs.github.com/en/actions/reference/authentication-in-a-workflow#permissions-for-the-github_token) for details.
