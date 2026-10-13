// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SupportTicketSummary _$SupportTicketSummaryFromJson(
  Map<String, dynamic> json,
) => _SupportTicketSummary(
  ticketId: json['ticketId'] as String,
  reference: json['reference'] as String,
  subject: json['subject'] as String,
  status: json['status'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  lastActivityAt: DateTime.parse(json['lastActivityAt'] as String),
);

Map<String, dynamic> _$SupportTicketSummaryToJson(
  _SupportTicketSummary instance,
) => <String, dynamic>{
  'ticketId': instance.ticketId,
  'reference': instance.reference,
  'subject': instance.subject,
  'status': instance.status,
  'createdAt': instance.createdAt.toIso8601String(),
  'lastActivityAt': instance.lastActivityAt.toIso8601String(),
};

_SupportTicket _$SupportTicketFromJson(Map<String, dynamic> json) =>
    _SupportTicket(
      ticketId: json['ticketId'] as String,
      reference: json['reference'] as String,
      subject: json['subject'] as String,
      details: json['details'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastActivityAt: DateTime.parse(json['lastActivityAt'] as String),
      closedAt: json['closedAt'] == null
          ? null
          : DateTime.parse(json['closedAt'] as String),
    );

Map<String, dynamic> _$SupportTicketToJson(_SupportTicket instance) =>
    <String, dynamic>{
      'ticketId': instance.ticketId,
      'reference': instance.reference,
      'subject': instance.subject,
      'details': instance.details,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastActivityAt': instance.lastActivityAt.toIso8601String(),
      'closedAt': instance.closedAt?.toIso8601String(),
    };

_SupportTicketMessage _$SupportTicketMessageFromJson(
  Map<String, dynamic> json,
) => _SupportTicketMessage(
  messageId: json['messageId'] as String,
  authorKind: json['authorKind'] as String,
  body: json['body'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$SupportTicketMessageToJson(
  _SupportTicketMessage instance,
) => <String, dynamic>{
  'messageId': instance.messageId,
  'authorKind': instance.authorKind,
  'body': instance.body,
  'createdAt': instance.createdAt.toIso8601String(),
};
