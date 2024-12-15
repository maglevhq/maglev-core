let proConfig = { content: [] };

try {
  proConfig = require('./tailwind-maglev-pro.config.js')
} catch(err) { 
  console.log('No extra Maglev Pro Tailwindcss config');
} 

export default {
  content: [
    './**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.{js,vue}',
    './app/frontend/**/*.{js,vue}'
  ].concat(proConfig.content),
  theme: {
    extend: {
      colors: {
        'editor-primary': 'rgb(var(--editor-color-primary-rgb) / <alpha-value>)',
        'gray': {
          '100': '#f5f5f5',
          '200': '#eeeeee',
          '300': '#e0e0e0',
          '400': '#bdbdbd',
          '500': '#9e9e9e',
          '600': '#757575',
          '700': '#616161',
          '800': '#424242',
          '900': '#212121',
        }
      },
      spacing: {
        'full': '100%',
        '1/2': '0.125rem',
        '72': '18rem',
        '84': '21rem',
        '96': '24rem',
        '104': '26rem',
        '108': '27rem',
        '120': '30rem',
        '128': '32rem',
        '144': '36rem',
        '168': '42rem',
        '216': '54rem',
      },
      inset: {
        '0': 0,
        'full': '100%',
        'auto': 'auto',
        '12': '3rem',
        '16': '4rem',
        '20': '5rem',
        '24': '6rem',
        '32': '8rem',
      },
    },
    fontFamily: {
      'nunito': ['Nunito Sans', 'sans-serif'],
    }, 
  },
  variants: {
    extend: {
      opacity: ['responsive', 'hover', 'focus', 'disabled'],
    },
  },
  plugins: [],
}
