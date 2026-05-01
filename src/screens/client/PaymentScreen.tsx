import React, { useState } from 'react';
import {
  View, Text, ScrollView, TouchableOpacity,
  StyleSheet, Linking, Alert,
} from 'react-native';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../../constants/Colors';
import { GoldButton } from '../../components/GoldButton';
import { GoldDivider, SectionLabel } from '../../components/GoldDivider';
import { useApp } from '../../context/AppContext';
import type { RootStackParamList } from '../../navigation/types';
import type { Order } from '../../types';

type Props = NativeStackScreenProps<RootStackParamList, 'Payment'>;

const METHODS = [
  { id: 'card', label: 'Carte Bancaire', icon: 'card-outline' as const, desc: 'Visa / Mastercard' },
  { id: 'mpesa', label: 'M-Pesa', icon: 'phone-portrait-outline' as const, desc: 'Vodacom Congo' },
  { id: 'orange', label: 'Orange Money', icon: 'phone-portrait-outline' as const, desc: 'Orange RDC' },
  { id: 'africell', label: 'Africell Money', icon: 'phone-portrait-outline' as const, desc: 'Africell RDC' },
];

export default function PaymentScreen({ navigation }: Props) {
  const { state, addOrder, clearCart } = useApp();
  const [method, setMethod] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const items = state.cart;
  const total = items.reduce((sum, i) => sum + i.product.price * i.quantity, 0);
  const formatted = new Intl.NumberFormat('fr-CD', { style: 'currency', currency: 'USD', maximumFractionDigits: 0 }).format(total);

  const handlePay = async () => {
    if (!method) {
      Alert.alert('Méthode requise', 'Veuillez sélectionner un mode de paiement.');
      return;
    }
    setLoading(true);

    const ref = `VC${Date.now()}`;
    const gatewayUrl = `https://dashboard.flexpay.cd/gateway?merchant=vcreations&ref=${ref}&amount=${total}&currency=USD&method=${method}`;

    try {
      await Linking.openURL(gatewayUrl);
    } catch {
      // Gateway not reachable in demo — simulate success
    }

    await new Promise(r => setTimeout(r, 1200));

    const order: Order = {
      id: ref,
      clientName: state.user?.name ?? 'Client',
      items: [...items],
      total,
      status: 'confirmée',
      paymentMethod: method,
      placedAt: 'À l\'instant',
    };
    addOrder(order);
    clearCart();
    setLoading(false);
    navigation.replace('Confirmation', { orderId: ref });
  };

  return (
    <ScrollView style={styles.container} contentContainerStyle={styles.content}>
      <TouchableOpacity onPress={() => navigation.goBack()} style={styles.back}>
        <Ionicons name="arrow-back" size={22} color={Colors.white} />
      </TouchableOpacity>

      <Text style={styles.title}>Paiement</Text>
      <View style={{ height: 20 }} />
      <GoldDivider />
      <View style={{ height: 24 }} />

      <SectionLabel text="Récapitulatif" />
      <View style={styles.summary}>
        {items.map(i => (
          <View key={i.id} style={styles.summaryRow}>
            <Text style={styles.summaryName} numberOfLines={1}>{i.product.name} × {i.quantity}</Text>
            <Text style={styles.summaryPrice}>
              {new Intl.NumberFormat('fr-CD', { style: 'currency', currency: 'USD', maximumFractionDigits: 0 }).format(i.product.price * i.quantity)}
            </Text>
          </View>
        ))}
        <View style={styles.totalRow}>
          <Text style={styles.totalLabel}>Total</Text>
          <Text style={styles.totalAmount}>{formatted}</Text>
        </View>
      </View>

      <View style={{ height: 24 }} />
      <SectionLabel text="Mode de paiement" />
      <View style={{ height: 12 }} />

      {METHODS.map(m => (
        <TouchableOpacity
          key={m.id}
          style={[styles.methodCard, method === m.id && styles.methodCardActive]}
          onPress={() => setMethod(m.id)}
        >
          <View style={styles.methodIcon}>
            <Ionicons name={m.icon} size={22} color={method === m.id ? Colors.gold : Colors.textSecondary} />
          </View>
          <View style={{ flex: 1 }}>
            <Text style={[styles.methodLabel, method === m.id && { color: Colors.gold }]}>{m.label}</Text>
            <Text style={styles.methodDesc}>{m.desc}</Text>
          </View>
          <View style={[styles.radio, method === m.id && styles.radioActive]}>
            {method === m.id && <View style={styles.radioDot} />}
          </View>
        </TouchableOpacity>
      ))}

      <View style={{ height: 32 }} />
      <GoldButton label={`Payer ${formatted}`} onPress={handlePay} loading={loading} />
      <Text style={styles.secure}>
        <Ionicons name="lock-closed-outline" size={11} color={Colors.textMuted} /> Paiement sécurisé via FlexPay
      </Text>
      <View style={{ height: 60 }} />
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: Colors.background },
  content: { padding: 20, paddingTop: 52 },
  back: { marginBottom: 16, width: 36 },
  title: { color: Colors.white, fontSize: 28, fontWeight: '700' },
  summary: {
    backgroundColor: Colors.surface, borderRadius: 14,
    borderWidth: 1, borderColor: Colors.cardBorder, padding: 16,
  },
  summaryRow: { flexDirection: 'row', justifyContent: 'space-between', marginBottom: 10 },
  summaryName: { color: Colors.textSecondary, fontSize: 13, flex: 1, marginRight: 8 },
  summaryPrice: { color: Colors.white, fontSize: 13, fontWeight: '600' },
  totalRow: {
    flexDirection: 'row', justifyContent: 'space-between',
    paddingTop: 12, marginTop: 4,
    borderTopWidth: 1, borderTopColor: Colors.divider,
  },
  totalLabel: { color: Colors.white, fontSize: 15, fontWeight: '700' },
  totalAmount: { color: Colors.gold, fontSize: 18, fontWeight: '700' },
  methodCard: {
    flexDirection: 'row', alignItems: 'center', gap: 14,
    backgroundColor: Colors.surface, borderRadius: 14,
    borderWidth: 1, borderColor: Colors.cardBorder,
    padding: 16, marginBottom: 10,
  },
  methodCardActive: { borderColor: Colors.gold, backgroundColor: Colors.goldFaint },
  methodIcon: { width: 36, alignItems: 'center' },
  methodLabel: { color: Colors.white, fontSize: 14, fontWeight: '600' },
  methodDesc: { color: Colors.textMuted, fontSize: 12, marginTop: 2 },
  radio: {
    width: 20, height: 20, borderRadius: 10,
    borderWidth: 1.5, borderColor: Colors.cardBorder,
    alignItems: 'center', justifyContent: 'center',
  },
  radioActive: { borderColor: Colors.gold },
  radioDot: { width: 10, height: 10, borderRadius: 5, backgroundColor: Colors.gold },
  secure: { color: Colors.textMuted, fontSize: 11, textAlign: 'center', marginTop: 12 },
});
