module.exports = {
  root: true,
  env: {
    browser: true,
    node: true,
    jest: true,
  },
  extends: [
    'eslint:recommended',
    'plugin:vue/essential',
    'prettier'
  ],
  parserOptions: {
    ecmaVersion: 2020,
  },
  rules: {
    'no-console': process.env.NODE_ENV === 'production' ? 'warn' : 'off',
    'no-debugger': process.env.NODE_ENV === 'production' ? 'warn' : 'off',
    quotes: [2, 'single', { avoidEscape: true, allowTemplateLiterals: true }],
    // 'prettier': [
    //   'warn',
    //   {
    //     semi: false,
    //     trailingComma: 'all',
    //     singleQuote: true,
    //     printWidth: 80,
    //     tabWidth: 2,
    //     arrow_parens: 'avoid',
    //     endOfLine: 'lf',
    //   },
    // ],
  },
  overrides: [
    {
      files: [
        '**/__tests__/*.{j,t}s?(x)',
        '**/tests/unit/**/*.spec.{j,t}s?(x)',
      ],
      env: {
        jest: true,
      },
    },
  ],
  ignorePatterns: [
    "app/javascript/controllers/**/*.js",
    "app/javascript/packs/**/*.js",
    "app/javascript/utils/**/*.js"
  ],
}
