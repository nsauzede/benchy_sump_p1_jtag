TARGET=rom.vhd

all:$(TARGET)

rom.vhd:rom.psm ROM_form.vhd
	picoasm -i $< -t ROM_form.vhd

clean:
	$(RM) $(TARGET)

clobber: clean
	$(RM) *~ rom.log
