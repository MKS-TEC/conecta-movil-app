
import 'package:cloud_firestore/cloud_firestore.dart';

class Episode {
  String? recordId;
  String? petId;
  String? episodeId;
  String? episode;
  String? details;
  String? diagnose;
  String? comment;
  String? instructionsAditionals;
  List<String>? reasons;
  DateTime? date;
  DateTime? createdOn;

  Episode();

  Map<String, dynamic> toMap() => {
    "eid": recordId,
    "episodioId": episodeId,
    "episodio": episode,
    "diagnosticoConsulta": diagnose,
    "detalleConsulta": details,
    "comentariosConsulta": comment,
    "motivoConsulta": reasons,
    "instruccionesAdicionalesConsulta": instructionsAditionals,
    "fechaConsulta": date,
    "createdOn": FieldValue.serverTimestamp(),
  };

  Episode.fromMap(Map<String, dynamic> map) {
    try {
      this.recordId = map["eid"] ?? "";
      this.episodeId = map["idConsulta"] ?? "";
      this.episode = map["episodio"] ?? 0;
      this.details = map["detalleConsulta"] ?? "";
      this.diagnose = map["diagnosticoConsulta"] ?? "";
      this.comment = map["comentariosConsulta"] ?? "";
      this.instructionsAditionals = map["instruccionesAdicionalesConsulta"] ?? "";
      this.reasons = map["motivoConsulta"] != null ? map["motivoConsulta"] : List<String>.empty(growable: true);
      this.date = map["fechaConsulta"] != null ? map["fechaConsulta"].toDate() : null;
      this.createdOn = map["createdOn"] != null ? map["createdOn"].toDate() : null;
    } catch (e) {
      print(e);
    }
  }
}