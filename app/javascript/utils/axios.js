import axios from 'axios'

const token = document.querySelector('[name="csrf-token"]') || {
  content: 'no-csrf-token',
}
const instance = axios.create({
  headers: {
    common: {
      'X-CSRF-TOKEN': token.content,
      'Content-Type': 'application/json',
      Accept: 'application/json',
    },
  },
})

export default instance
