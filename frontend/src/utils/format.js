export function money(value) {
  const number = Number(value || 0)
  return new Intl.NumberFormat('zh-CN', {
    style: 'currency',
    currency: 'CNY',
    maximumFractionDigits: 0
  }).format(number)
}

export function imageUrl(url) {
  if (!url) return ''
  if (/^https?:\/\//i.test(url)) return url
  return url.startsWith('/') ? url : `/${url}`
}

export function shortText(text, fallback = '为下一刻体验而设计。') {
  if (!text) return fallback
  return String(text).replace(/\s+/g, ' ').trim()
}
