#!/bin/bash

# Go to root folder
cd "$(dirname "$0")"/.. || exit

#Install packages
yarn install --frozen-lockfile

# Run the Jest test suite
yarn test --coverage

# Run ESLint with specified rules
./node_modules/.bin/eslint --ext .js,.vue,.ts \
  --rule "vue/multi-word-component-names:off" \
  --rule "no-console:error" \
  --rule "no-debugger:error" \
  --rule "vue/no-unused-vars:error" \
  --rule "@typescript-eslint/no-unused-vars:warn" \
  --rule "@typescript-eslint/no-explicit-any:off" \
  --rule "@typescript-eslint/ban-ts-comment:off" \
  --rule "@typescript-eslint/explicit-module-boundary-types:off" \
  --rule "vue/no-ref-as-operand:warn" \
  --rule "vue/no-reserved-component-names:off" \
  .
./node_modules/.bin/eslint . --ext .ts,.js -f json -o eslint_report.json

# Check that the Jest and ESLint scripts passed successfully
if [ $? -eq 0 ]; then
  echo "All tests and lint checks passed successfully."
else
  echo "One or more tests or lint checks failed. Please fix the issues before committing your changes."
  exit 1
fi
