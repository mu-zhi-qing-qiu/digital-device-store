import { getImages } from '@/api/product'
import { imageUrl } from '@/utils/format'

export async function attachProductImages(products) {
  const list = Array.isArray(products) ? products : []
  const pairs = await Promise.all(
    list.map(async product => {
      try {
        const images = await getImages(product.id)
        return [product.id, imageUrl(images?.[0]?.url || '')]
      } catch {
        return [product.id, '']
      }
    })
  )
  return Object.fromEntries(pairs)
}
