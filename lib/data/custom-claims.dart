

enum CustomClaims {
  storeOwner,
  buyer,
}

String customClaimsToPlainText(CustomClaims customClaim) => {
  CustomClaims.storeOwner: 'storeOwner: true (buyer: false)',
  CustomClaims.buyer: 'buyer: true (storeOwner: false)',
}[customClaim]!;