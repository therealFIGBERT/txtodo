//
//  DonationSection.swift
//  txtodo
//
//  Created by FIGBERT on 11/16/20.
//

import SwiftUI

struct DonationSection: View {
    @StateObject var storeManager: StoreManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Text("considerDonating")
                .multilineTextAlignment(.center)
                .padding()
            HStack {
                ForEach(storeManager.myProducts.sorted(by: { first, second in return first.price.doubleValue < second.price.doubleValue }), id: \.self) { product in
                    Text(product.priceFormatted())
                        .foregroundColor(Color.white)
                        .padding()
                        .background(Color.blue.opacity(self.colorScheme == .dark ? 0.3 : 0.75).cornerRadius(10))
                        .onTapGesture {
                            self.storeManager.purchaseProduct(product: product)
                        }
                }
            }
                .padding(.bottom)
        }
    }
}

struct DonationSection_Previews: PreviewProvider {
    static var previews: some View {
        DonationSection(storeManager: StoreManager())
    }
}
