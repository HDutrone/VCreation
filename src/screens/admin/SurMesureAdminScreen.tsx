import React, { useState } from 'react';
import {
  View, Text, FlatList, TouchableOpacity, TextInput,
  StyleSheet, Alert,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../../constants/Colors';
import { StatusBadge } from '../../components/GoldDivider';
import { useApp } from '../../context/AppContext';
import type { CustomRequest } from '../../types';

export default function SurMesureAdminScreen() {
  const { state, replyToRequest, updateRequestStatus } = useApp();
  const [expanded, setExpanded] = useState<string | null>(null);
  const [reply, setReply] = useState('');

  const requests = [...state.customRequests].reverse();

  const sendReply = (req: CustomRequest) => {
    if (!reply.trim()) return;
    replyToRequest(req.id, reply.trim());
    setReply('');
    Alert.alert('Réponse envoyée', 'Le client sera notifié de votre réponse.');
  };

  const changeStatus = (req: CustomRequest) => {
    const statuses: CustomRequest['status'][] = ['nouvelle', 'en_cours', 'devis_envoyé', 'acceptée', 'refusée'];
    Alert.alert('Statut', `Demande de ${req.clientName}`, [
      ...statuses.map(s => ({
        text: s.replace('_', ' ').charAt(0).toUpperCase() + s.replace('_', ' ').slice(1),
        onPress: () => updateRequestStatus(req.id, s),
      })),
      { text: 'Annuler', style: 'cancel' },
    ]);
  };

  if (requests.length === 0) {
    return (
      <View style={styles.empty}>
        <Ionicons name="cut-outline" size={64} color={Colors.textMuted} />
        <Text style={styles.emptyTitle}>Aucune demande</Text>
        <Text style={styles.emptyDesc}>Les demandes sur-mesure clients apparaîtront ici.</Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Sur-Mesure</Text>
        <View style={styles.badge}>
          <Text style={styles.badgeText}>
            {requests.filter(r => r.status === 'nouvelle').length} nouvelle{requests.filter(r => r.status === 'nouvelle').length > 1 ? 's' : ''}
          </Text>
        </View>
      </View>

      <FlatList
        data={requests}
        keyExtractor={r => r.id}
        contentContainerStyle={styles.list}
        showsVerticalScrollIndicator={false}
        ItemSeparatorComponent={() => <View style={{ height: 10 }} />}
        renderItem={({ item }) => {
          const isExpanded = expanded === item.id;
          return (
            <View style={[styles.card, item.status === 'nouvelle' && styles.cardNew]}>
              <TouchableOpacity
                onPress={() => setExpanded(isExpanded ? null : item.id)}
                style={styles.cardHeader}
              >
                <View style={{ flex: 1 }}>
                  <Text style={styles.clientName}>{item.clientName}</Text>
                  <Text style={styles.garment}>{item.garmentType} • {item.occasion}</Text>
                </View>
                <StatusBadge status={item.status} />
                <Ionicons
                  name={isExpanded ? 'chevron-up' : 'chevron-down'}
                  size={16} color={Colors.textMuted} style={{ marginLeft: 8 }}
                />
              </TouchableOpacity>

              {isExpanded && (
                <View style={styles.cardBody}>
                  <View style={styles.divider} />
                  <InfoRow label="Tenue" value={item.garmentType} />
                  <InfoRow label="Occasion" value={item.occasion} />
                  <InfoRow label="Délai" value={item.delai} />
                  <InfoRow label="Message" value={item.message} />
                  <InfoRow label="Reçue" value={item.receivedAt} />
                  {item.adminReply && (
                    <View style={styles.replyBox}>
                      <Text style={styles.replyLabel}>Votre réponse</Text>
                      <Text style={styles.replyText}>{item.adminReply}</Text>
                    </View>
                  )}
                  <View style={styles.replyInputRow}>
                    <TextInput
                      style={styles.replyInput}
                      placeholder="Écrire une réponse..."
                      placeholderTextColor={Colors.textMuted}
                      value={reply}
                      onChangeText={setReply}
                    />
                    <TouchableOpacity onPress={() => sendReply(item)} style={styles.sendBtn}>
                      <Ionicons name="send" size={18} color={Colors.gold} />
                    </TouchableOpacity>
                  </View>
                  <TouchableOpacity onPress={() => changeStatus(item)} style={styles.statusBtn}>
                    <Ionicons name="create-outline" size={14} color={Colors.gold} />
                    <Text style={styles.statusBtnText}>Changer le statut</Text>
                  </TouchableOpacity>
                </View>
              )}
            </View>
          );
        }}
      />
    </View>
  );
}

function InfoRow({ label, value }: { label: string; value: string }) {
  return (
    <View style={styles.infoRow}>
      <Text style={styles.infoLabel}>{label}:</Text>
      <Text style={styles.infoValue}>{value}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: Colors.background },
  header: {
    flexDirection: 'row', alignItems: 'center', gap: 12,
    paddingHorizontal: 20, paddingTop: 52, paddingBottom: 12,
  },
  title: { color: Colors.white, fontSize: 32, fontWeight: '700', flex: 1 },
  badge: {
    paddingHorizontal: 12, paddingVertical: 5,
    backgroundColor: Colors.error + '22', borderRadius: 20, borderWidth: 1, borderColor: Colors.error + '66',
  },
  badgeText: { color: Colors.error, fontSize: 12 },
  list: { paddingHorizontal: 20, paddingTop: 4, paddingBottom: 100 },
  card: {
    backgroundColor: Colors.surface, borderRadius: 14,
    borderWidth: 1, borderColor: Colors.cardBorder, overflow: 'hidden',
  },
  cardNew: { borderColor: Colors.gold + '66' },
  cardHeader: { flexDirection: 'row', alignItems: 'center', padding: 14, gap: 8 },
  clientName: { color: Colors.white, fontSize: 14, fontWeight: '700' },
  garment: { color: Colors.textMuted, fontSize: 12, marginTop: 2 },
  cardBody: { paddingHorizontal: 14, paddingBottom: 14 },
  divider: { height: 1, backgroundColor: Colors.divider, marginBottom: 12 },
  infoRow: { flexDirection: 'row', gap: 8, marginBottom: 6 },
  infoLabel: { color: Colors.textMuted, fontSize: 13, minWidth: 60 },
  infoValue: { color: Colors.white, fontSize: 13, flex: 1 },
  replyBox: {
    backgroundColor: Colors.goldFaint, borderRadius: 8, padding: 10, marginVertical: 10,
    borderWidth: 1, borderColor: Colors.gold + '33',
  },
  replyLabel: { color: Colors.gold, fontSize: 11, marginBottom: 4 },
  replyText: { color: Colors.white, fontSize: 13 },
  replyInputRow: { flexDirection: 'row', gap: 10, alignItems: 'center', marginTop: 8 },
  replyInput: {
    flex: 1, backgroundColor: Colors.card, borderRadius: 10,
    borderWidth: 1, borderColor: Colors.cardBorder,
    paddingHorizontal: 12, paddingVertical: 10,
    color: Colors.white, fontSize: 13,
  },
  sendBtn: {
    width: 42, height: 42, borderRadius: 10,
    backgroundColor: Colors.goldFaint, borderWidth: 1, borderColor: Colors.gold + '66',
    alignItems: 'center', justifyContent: 'center',
  },
  statusBtn: {
    flexDirection: 'row', alignItems: 'center', gap: 6,
    marginTop: 10, alignSelf: 'flex-start',
    paddingHorizontal: 12, paddingVertical: 6,
    borderRadius: 8, borderWidth: 1, borderColor: Colors.gold + '66',
  },
  statusBtnText: { color: Colors.gold, fontSize: 13 },
  empty: { flex: 1, backgroundColor: Colors.background, alignItems: 'center', justifyContent: 'center', padding: 40 },
  emptyTitle: { color: Colors.white, fontSize: 20, fontWeight: '700', marginTop: 20 },
  emptyDesc: { color: Colors.textSecondary, fontSize: 14, textAlign: 'center', marginTop: 8 },
});
