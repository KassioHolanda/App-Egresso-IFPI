class Curso {
  String uid;
  String label;
  String nivel;

  Curso(this.uid, this.label, this.nivel);

  @override
  String toString() {
    return '${this.label} : ${this.nivel}';
  }
}
